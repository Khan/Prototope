//
//  ProtoscopeServer.swift
//  Prototope
//
//  Created by Andy Matuschak on 2/6/15.
//  Copyright (c) 2015 Khan Academy. All rights reserved.
//

import Foundation
import swiftz_core

class ProtoscopeServer {
	private let bonjourServer: DTBonjourServer
	private var serverDelegate: ServerDelegate?

	init(messageHandler: Message -> ()) {
		serverDelegate = ServerDelegate(messageHandler: messageHandler)
		bonjourServer = DTBonjourServer(bonjourType: ProtoropeReceiverServiceType)
		bonjourServer.delegate = serverDelegate!
		bonjourServer.start()
	}

	func stop() {
		bonjourServer.delegate = nil
		bonjourServer.stop()
		serverDelegate = nil
	}

	deinit {
		stop()
	}

	@objc private class ServerDelegate: NSObject, DTBonjourServerDelegate {
		let messageHandler: Message -> ()

		init(messageHandler: Message -> ()) {
			self.messageHandler = messageHandler
		}

		@objc private func bonjourServer(server: DTBonjourServer!, didReceiveObject object: AnyObject!, onConnection connection: DTBonjourDataConnection!) {
			if let data = object as? NSData {
				if let message = JSONValue.decode(data) >>- Message.fromJSON {
					messageHandler(message)
				} else {
					println("Received unknown message: \(NSString(data: data, encoding: NSUTF8StringEncoding))")
				}
			}
		}
	}
}
