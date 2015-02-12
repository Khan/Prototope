//
//  ViewController.swift
//  Protocaster
//
//  Created by Andy Matuschak on 2/6/15.
//  Copyright (c) 2015 Khan Academy. All rights reserved.
//

import Cocoa
import swiftz_core

class ViewController: NSViewController, DTBonjourDataConnectionDelegate {

	var scanner: ProtoscopeScanner!
	var monitor: URLMonitor?

	var connection: DTBonjourDataConnection?
	var selectedDeviceSession: NSNetService?

	@IBOutlet var deviceListController: NSArrayController!
	@IBOutlet weak var deviceChooserButton: NSPopUpButton!

	@IBAction func pathControlDidChange(sender: NSPathControl) {
		if let URL = sender.URL {
			monitor = URLMonitor(URL: URL)
			monitor!.everythingDidChangeHandler = {
				self.sendPrototypeData()
			}

			sendPrototypeData()
		} else {
			monitor = nil
		}
	}

	@IBAction func deviceSelectionDidChange(sender: NSPopUpButton) {
		self.connection?.close()
		self.connection?.delegate = nil
		if selectedDeviceSession != nil {
			self.connection = DTBonjourDataConnection(service: selectedDeviceSession)
			self.connection!.open()
			self.connection!.delegate = self
		}
	}

	override func viewDidLoad() {
		scanner = ProtoscopeScanner(
			serviceDidAppearHandler: { service in
				self.deviceListController.addObject(service)
			},
			serviceDidDisappearHandler: { service in
				if .Some(service) == self.selectedDeviceSession {
					self.selectedDeviceSession = nil
				}
				self.deviceListController.removeObject(service)
			}
		)
	}

	func connectionDidOpen(connection: DTBonjourDataConnection!) {
		sendPrototypeData()
	}

	func connection(connection: DTBonjourDataConnection!, didReceiveObject object: AnyObject!) {
		switch JSONValue.decode(object as! NSData) >>- Message.fromJSON {
		case let .Some(.PrototypeHitException(exception)):
			println("Exception: \(exception)")
		case let .Some(.PrototypeConsoleLog(message)):
			println("Console log: \(message)")
		default:
			println("Unknown message: \(object)")
		}
	}

	func sendPrototypeData() {
		if let selectedURL = monitor?.URL {
			if let prototype = Prototype(url: selectedURL) {
				let message = Message.ReplacePrototype(prototype)
				let messageJSON = Message.toJSON(message)
				connection?.sendObject(messageJSON.encode()!, error: nil)
			}
		}
	}

}

