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

    var statusBarItem: NSStatusItem!

    private var webservice = WebService()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        statusBarItem = makeStatusBarItem()
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

    // MARK: Private

    private func makeStatusBarItem() -> NSStatusItem {
        let statusBar = NSStatusBar.system
        let statusBarItem = statusBar.statusItem(withLength: NSStatusItem.variableLength)
        let menu = NSMenu()
        let title = "quit".localized
        menu.addItem(NSMenuItem(title: title, action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))

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
}
