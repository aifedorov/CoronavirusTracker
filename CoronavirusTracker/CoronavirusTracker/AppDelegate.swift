//
//  AppDelegate.swift
//  CoronavirusTracker
//
//  Created by Александр Федоров on 25.04.2020.
//  Copyright © 2020 Personal. All rights reserved.
//

import Cocoa
import SwiftUI

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    private var webservice = WebService()
    private var statusBarItem: NSStatusItem!
    private var timer: Timer!

    private enum Constants {
        static let errorTitle = "⚠️"
    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        statusBarItem = makeStatusBarItem()
        setupTimer()
    }

    // MARK: Private

    private func makeStatusBarItem() -> NSStatusItem {
        let statusBar = NSStatusBar.system
        let statusBarItem = statusBar.statusItem(withLength: NSStatusItem.variableLength)
        let menu = NSMenu()

        let refresh = "refresh".localized
        menu.addItem(NSMenuItem(title: refresh, action: #selector(refreshStats), keyEquivalent: "r"))

        menu.addItem(NSMenuItem.separator())

        let quit = "quit".localized
        menu.addItem(NSMenuItem(title: quit, action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))

        if let button = statusBarItem.button {
            button.title = "🦠⏳"
        }

        statusBarItem.menu = menu
        return statusBarItem
    }

    private func requestStats(completion: @escaping (CountryStats?) -> Void) {
        let url = URL(string: "https://corona.lmao.ninja/v2/countries/ru")!
        let resource = Resource<CountryStats>(url: url) { (data) -> CountryStats? in
            return try? JSONDecoder().decode(CountryStats.self, from: data)
        }

        webservice.load(resource) { stats in
            completion(stats)
        }
    }

    private func requestHistoryData(completion: @escaping (HistoryData?) -> Void) {
        let url = URL(string: "https://corona.lmao.ninja/v2/historical/ru")!
        let resource = Resource<HistoryData>(url: url) { (data) -> HistoryData? in
            return try? JSONDecoder().decode(HistoryData.self, from: data)
        }

        webservice.load(resource) { stats in
            completion(stats)
        }
    }

    @objc
    private func refreshStats() {
        let group = DispatchGroup()
        var countryStats: CountryStats?
        var historyData: HistoryData?

        group.enter()
        requestStats { (stats) in
            countryStats = stats
            group.leave()
        }

        group.enter()
        requestHistoryData { (history) in
            historyData = history
            group.leave()
        }

        let result = group.wait(timeout: DispatchTime.now() + 45)
        let title: String

        switch result {
        case .success:
            guard let stats = countryStats else {
                title = Constants.errorTitle
                break
            }
            title = makeTitle(historyData, stats)

        case .timedOut:
            title = Constants.errorTitle
        }

        DispatchQueue.main.async {
            guard let button = self.statusBarItem.button else { return }
            button.title = title
        }
    }

    private func setupTimer() {
        // Updating every 3 hours
        timer = Timer.scheduledTimer(withTimeInterval: 60 * 60 * 3, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.refreshStats()
        }

        timer.fire()
    }

    private func makeTitle(_ history: HistoryData?, _ stats: CountryStats?) -> String {
        guard let stats = stats else { return Constants.errorTitle }
        let trend = TrendHelper.calculateTrend(history, stats)
        return "\(trend)\(stats.todayCases)🦠\(stats.cases)💀\(stats.deaths)"
    }
}
