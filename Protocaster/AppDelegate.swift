//
//  AppDelegate.swift
//  Protocaster
//
//  Created by Andy Matuschak on 2/6/15.
//  Copyright (c) 2015 Khan Academy. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, DTBonjourDataConnectionDelegate {

	var scanner: ProtoscopeScanner!
	var connection: DTBonjourDataConnection?
	let monitor = FolderMonitor(folderPath: NSURL(fileURLWithPath: "/Users/andymatuschak/Desktop/test.js")!)

	func applicationDidFinishLaunching(aNotification: NSNotification) {
		monitor.everythingDidChangeHandler = {
			self.sendTestData()
		}

		scanner = ProtoscopeScanner(
			serviceDidAppearHandler: { service in
				println(service.name)
				self.connection = DTBonjourDataConnection(service: service)
				self.connection!.open()
				self.connection!.delegate = self
			},
			serviceDidDisappearHandler: { service in
				println(service.name)
			}
		)
	}

	func connectionDidOpen(connection: DTBonjourDataConnection!) {
		sendTestData()
	}

	func sendTestData() {
		let testFileData = NSData(contentsOfFile: "/Users/andymatuschak/Desktop/test.js")
		connection?.sendObject(testFileData, error: nil)
	}

	func applicationWillTerminate(aNotification: NSNotification) {
		// Insert code here to tear down your application
	}


}

