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
	private var currentConnection: DTBonjourDataConnection?

	init(messageHandler: Message -> ()) {
		bonjourServer = DTBonjourServer(bonjourType: ProtoropeReceiverServiceType)
		serverDelegate = ServerDelegate(
			connectionHandler: { [weak self] connection in
				self?.currentConnection = connection
				return
			},
			messageHandler: messageHandler
		)
		bonjourServer.delegate = serverDelegate!
		bonjourServer.start()
	}

	func sendMessage(message: Message) {
		currentConnection?.sendObject(Message.toJSON(message).encode()!, error: nil)
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
		let connectionHandler: DTBonjourDataConnection -> ()
		let messageHandler: Message -> ()

		init(connectionHandler: DTBonjourDataConnection -> (), messageHandler: Message -> ()) {
			self.connectionHandler = connectionHandler
			self.messageHandler = messageHandler
		}

		@objc private func bonjourServer(server: DTBonjourServer!, didAcceptConnection connection: DTBonjourDataConnection!) {
			connectionHandler(connection)
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
