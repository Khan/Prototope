//
//  ProtoscopeScanner.swift
//  Prototope
//
//  Created by Andy Matuschak on 2/6/15.
//  Copyright (c) 2015 Khan Academy. All rights reserved.
//

import Foundation

class ProtoscopeScanner {
	private let browser = NSNetServiceBrowser()
	private let browserDelegate: BrowserDelegate!
	private(set) var services: [NSNetService] = []

	init(serviceDidAppearHandler: NSNetService -> () = {_ in return}, serviceDidDisappearHandler: NSNetService -> () = {_ in return}) {
		browserDelegate = BrowserDelegate(
			serviceDidAppearHandler: { [unowned self] service in
				self.services.append(service)
				serviceDidAppearHandler(service)
			},
			serviceDidDisappearHandler: { [unowned self] service in
				self.services = self.services.filter { $0 !== service }
				serviceDidDisappearHandler(service)
			}
		)
		browser.delegate = browserDelegate
		browser.searchForServicesOfType(ProtoropeReceiverServiceType, inDomain: "")
	}

	func stop() {
		browser.delegate = nil
		browser.stop()
	}

	deinit {
		stop()
	}

	@objc private class BrowserDelegate: NSObject, NSNetServiceBrowserDelegate {
		let serviceDidAppearHandler: NSNetService -> ()
		let serviceDidDisappearHandler: NSNetService -> ()

		init(serviceDidAppearHandler: NSNetService -> (), serviceDidDisappearHandler: NSNetService -> ()) {
			self.serviceDidAppearHandler = serviceDidAppearHandler
			self.serviceDidDisappearHandler = serviceDidDisappearHandler
		}

		private func netServiceBrowser(aNetServiceBrowser: NSNetServiceBrowser, didFindService aNetService: NSNetService, moreComing: Bool) {
			serviceDidAppearHandler(aNetService)
		}

		private func netServiceBrowser(aNetServiceBrowser: NSNetServiceBrowser, didRemoveService aNetService: NSNetService, moreComing: Bool) {
			serviceDidDisappearHandler(aNetService)
		}
	}
}