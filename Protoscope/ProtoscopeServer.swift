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
	init(name: String) {
		bonjourServer = DTBonjourServer(bonjourType: ProtoropeReceiverServiceType)
		bonjourServer.start()
	}

	func stop() {
		bonjourServer.stop()
	}

	deinit {
		stop()
	}
}
