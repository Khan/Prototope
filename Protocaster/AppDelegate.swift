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
	var connection: DTBonjourDataConnection!

	func applicationDidFinishLaunching(aNotification: NSNotification) {
		scanner = ProtoscopeScanner(
			serviceDidAppearHandler: { service in
				println(service.name)
				self.connection = DTBonjourDataConnection(service: service)
				self.connection.open()
				self.connection.delegate = self
			},
			serviceDidDisappearHandler: { service in
				println(service.name)
			}
		)
	}

	func connectionDidOpen(connection: DTBonjourDataConnection!) {
		connection.sendObject("hey listen", error: nil)
	}

	func applicationWillTerminate(aNotification: NSNotification) {
		// Insert code here to tear down your application
	}


}

