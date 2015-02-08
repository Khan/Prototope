//
//  ViewController.swift
//  Protocaster
//
//  Created by Andy Matuschak on 2/6/15.
//  Copyright (c) 2015 Khan Academy. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, DTBonjourDataConnectionDelegate {

	var scanner: ProtoscopeScanner!
	var connection: DTBonjourDataConnection?
	var monitor: URLMonitor?

	@IBAction func pathControlDidChange(sender: NSPathControl) {
		if let URL = sender.URL {
			monitor = URLMonitor(URL: URL)
			monitor!.everythingDidChangeHandler = {
				self.sendTestData()
			}

			sendTestData()
		} else {
			monitor = nil
		}
	}

	override func viewDidLoad() {

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
		if let selectedURL = monitor?.URL {
			let testFileData = NSData(contentsOfURL: selectedURL)
			connection?.sendObject(testFileData, error: nil)
		}
	}

}

