//
//  LogViewController.swift
//  Prototope
//
//  Created by Andy Matuschak on 2/11/15.
//  Copyright (c) 2015 Khan Academy. All rights reserved.
//

import AppKit

class LogViewController: NSViewController {

	func appendConsoleMessage(message: String) {
		logTextView.textStorage!.appendAttributedString(NSAttributedString(string: message))
	}

	@IBAction func clear(sender: AnyObject) {
		logTextView.textStorage!.deleteCharactersInRange(NSMakeRange(0, logTextView.textStorage!.length))
	}

	@IBOutlet var logTextView: NSTextView!

}
