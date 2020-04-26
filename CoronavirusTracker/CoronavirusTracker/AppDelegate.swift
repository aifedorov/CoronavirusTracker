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

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        statusBarItem = makeStatusBarItem()
        setupTimer()
    }

    // MARK: Private

    private func makeStatusBarItem() -> NSStatusItem {
        let statusBar = NSStatusBar.system
        let statusBarItem = statusBar.statusItem(withLength: NSStatusItem.variableLength)
        let menu = NSMenu()
        let title = "quit".localized
        menu.addItem(NSMenuItem(title: title, action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))

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

    private func refreshStats() {
        requestStats { [unowned self] (stats) in
            let title: String
            if let stats = stats {
                title = "🔼\(stats.todayCases)🦠\(stats.cases)💀\(stats.deaths)"
            } else {
                title = "⚠️"
            }

            DispatchQueue.main.async {
                guard let button = self.statusBarItem.button else { return }
                button.title = title
            }
        }
    }

    func setupTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 60 * 60 * 12, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.refreshStats()
        }

        timer.fire()
    }
}
