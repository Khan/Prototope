//
//  AppDelegate.swift
//  Protocaster
//
//  Created by Andy Matuschak on 2/6/15.
//  Copyright (c) 2015 Khan Academy. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
	var logWindowController: LogWindowController!

	func applicationDidFinishLaunching(notification: NSNotification) {
		let windows = NSApplication.sharedApplication().windows as! [NSWindow]

		let storyboard = NSStoryboard(name: "Main", bundle: nil)
		logWindowController = storyboard?.instantiateControllerWithIdentifier("Log") as! LogWindowController
		logWindowController.showWindow(nil)

		// I have no idea why this dance is required.
		windows.first!.makeKeyWindow()
		logWindowController.window!.orderFrontRegardless()

		logWindowController.appendConsoleMessage("HIIIII")
	}
}

