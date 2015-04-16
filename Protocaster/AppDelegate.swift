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
	private var mainViewController: ViewController! // TODO: rename, make window controller
	private var logWindowController: LogWindowController!

	private var scanner: ProtoscopeScanner!
	private var monitor: URLMonitor?

	private var connection: DTBonjourDataConnection?

	private var selectedDeviceSession: NSNetService? {
		didSet {
			mainViewController.selectedDeviceSession = selectedDeviceSession

			connection?.close()
			connection?.delegate = nil
			if selectedDeviceSession != nil {
				connection = DTBonjourDataConnection(service: selectedDeviceSession)
				connection!.open()
				connection!.delegate = self
			}
		}
	}
	
	private var lastShownNotificationException: String? = nil
    
    private final func sceneURL(fromURL URL: NSURL) -> NSURL? {
        var isDirectoryValue: AnyObject?
        URL.getResourceValue(&isDirectoryValue, forKey: NSURLIsDirectoryKey, error: nil)
        
        let isDirectory = (isDirectoryValue as? NSNumber)?.boolValue ?? false
        
        if !isDirectory {
            return URL.URLByDeletingLastPathComponent
        }
        
        return URL
    }

	private func selectedPathDidChange(newURL: NSURL?) {
        if let URL = newURL, let sceneURL = sceneURL(fromURL: URL) {
			if .Some(URL) != monitor?.URL {
				monitor = URLMonitor(URL: URL)
				monitor!.everythingDidChangeHandler = {
					self.logWindowController.appendReloadMessage()
					self.sendPrototypeData()
				}

				sendPrototypeData()

				self.logWindowController.appendPrototypeChangedMessage(URL)
			}
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

		mainViewController = mainWindow.contentViewController! as! ViewController
		mainViewController.selectedPathDidChange = { [weak self] in
			self?.selectedPathDidChange($0)
			return
		}
		mainViewController.selectedDeviceDidChange = { [weak self] in
			self?.selectedDeviceSession = $0
			return
		}

		scanner = ProtoscopeScanner(
			serviceDidAppearHandler: { [weak self] service in
				self?.mainViewController.addService(service)
				return
			},
			serviceDidDisappearHandler: { [weak self] service in
				if let strongSelf = self {
					if .Some(service) == strongSelf.selectedDeviceSession {
						strongSelf.selectedDeviceSession = nil
					}
					strongSelf.mainViewController.removeService(service)
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
			logWindowController.appendException(exception)
			
			if lastShownNotificationException != exception {
				let notification = NSUserNotification()
				notification.title = "Protonope!"
				notification.informativeText = exception
				NSUserNotificationCenter.defaultUserNotificationCenter().deliverNotification(notification)
				lastShownNotificationException = exception
			}
			
		case let .Some(.PrototypeConsoleLog(message)):
			logWindowController.appendConsoleMessage(message)
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

