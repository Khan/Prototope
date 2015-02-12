//
//  AppDelegate.swift
//  Protocaster
//
//  Created by Andy Matuschak on 2/6/15.
//  Copyright (c) 2015 Khan Academy. All rights reserved.
//

import Cocoa
import swiftz_core

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, DTBonjourDataConnectionDelegate {
	private var mainWindowController: ViewController!
	private var logWindowController: LogWindowController!

	private var scanner: ProtoscopeScanner!
	private var monitor: URLMonitor?

	private var connection: DTBonjourDataConnection?

	private var selectedDeviceSession: NSNetService? {
		didSet {
			mainWindowController.selectedDeviceSession = selectedDeviceSession

			connection?.close()
			connection?.delegate = nil
			if selectedDeviceSession != nil {
				connection = DTBonjourDataConnection(service: selectedDeviceSession)
				connection!.open()
				connection!.delegate = self
			}
		}
	}

	private func selectedPathDidChange(newURL: NSURL?) {
		if let URL = newURL {
			monitor = URLMonitor(URL: URL)
			monitor!.everythingDidChangeHandler = {
				self.sendPrototypeData()
			}

			sendPrototypeData()
		} else {
			monitor = nil
		}
	}

	func applicationDidFinishLaunching(notification: NSNotification) {
		let windows = NSApplication.sharedApplication().windows as! [NSWindow]

		let storyboard = NSStoryboard(name: "Main", bundle: nil)
		logWindowController = storyboard?.instantiateControllerWithIdentifier("Log") as! LogWindowController
		logWindowController.showWindow(nil)

		// I have no idea why this dance is required.
		let mainWindow = windows.first!
		mainWindow.makeKeyWindow()
		logWindowController.window!.orderFrontRegardless()

		mainWindowController = mainWindow.contentViewController! as! ViewController
		mainWindowController.selectedPathDidChange = { [weak self] in
			self?.selectedPathDidChange($0)
			return
		}
		mainWindowController.selectedDeviceDidChange = { [weak self] in
			self?.selectedDeviceSession = $0
			return
		}

		logWindowController.appendConsoleMessage("HIIIII")

		scanner = ProtoscopeScanner(
			serviceDidAppearHandler: { [weak self] service in
				self?.mainWindowController.addService(service)
				return
			},
			serviceDidDisappearHandler: { [weak self] service in
				if let strongSelf = self {
					if .Some(service) == strongSelf.selectedDeviceSession {
						strongSelf.selectedDeviceSession = nil
					}
					strongSelf.mainWindowController.removeService(service)
				}
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

