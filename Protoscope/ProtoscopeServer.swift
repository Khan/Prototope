//
//  ProtoscopeServer.swift
//  Prototope
//
//  Created by Andy Matuschak on 2/6/15.
//  Copyright (c) 2015 Khan Academy. All rights reserved.
//

import Foundation

class ProtoscopeServer {
	private let bonjourServer: DTBonjourServer
	private var serverDelegate: ServerDelegate?

	init(messageHandler: AnyObject -> ()) {
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
		let messageHandler: AnyObject -> ()

		init(messageHandler: AnyObject -> ()) {
			self.messageHandler = messageHandler
		}

		func bonjourServer(server: DTBonjourServer!, didReceiveObject object: AnyObject!, onConnection connection: DTBonjourDataConnection!) {
			messageHandler(object)
		}
	}
}
