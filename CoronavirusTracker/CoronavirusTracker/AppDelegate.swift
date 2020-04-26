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

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        statusBarItem = makeStatusBarItem()
    }

    // MARK: Private

    private func makeIcon() -> NSImage {
        let image = NSImage(named: NSImage.Name("status-bar-icon"))!
        image.size = NSSize(width: 20, height: 20)
        return image
    }

    private func makeStatusBarItem() -> NSStatusItem {
        let statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        let menu = NSMenu()
        let title = "quit".localized
        menu.addItem(NSMenuItem(title: title, action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))

        statusBarItem.menu = menu

        if let button = statusBarItem.button {
            button.image = makeIcon()
        }

        return statusBarItem
    }
}
