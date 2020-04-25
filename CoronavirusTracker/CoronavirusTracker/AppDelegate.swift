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
        statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)

        if let button = statusBarItem.button {
            button.image = #imageLiteral(resourceName: "coronavirus")
            button.action = #selector(printQuote(_:))
        }
    }

    @objc func printQuote(_ sender: Any?) {
      let quoteText = "Never put off until tomorrow what you can do the day after tomorrow."
      let quoteAuthor = "Mark Twain"

      print("\(quoteText) — \(quoteAuthor)")
    }
}
