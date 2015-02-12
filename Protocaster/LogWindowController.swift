//
//  LogWindowController.swift
//  Prototope
//
//  Created by Andy Matuschak on 2/11/15.
//  Copyright (c) 2015 Khan Academy. All rights reserved.
//

import AppKit

class LogWindowController: NSWindowController {
	private var logViewController: LogViewController {
		return window!.contentViewController! as! LogViewController
	}

	func appendConsoleMessage(message: String) {
		logViewController.appendConsoleMessage(message)
	}
}