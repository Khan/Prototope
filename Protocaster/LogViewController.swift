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
		appendMessage(message, attributes: [:])
	}

	func appendException(exception: String) {
		appendMessage(
			exception,
			attributes: [
				NSForegroundColorAttributeName: NSColor.whiteColor(),
				NSBackgroundColorAttributeName: NSColor(red: 233.0/255.0, green: 151.0/255.0, blue:17.0/255.0, alpha: 1.0)
			]
		)
	}

	func appendReloadMessage() {
		appendMessage(
			"(prototype reloaded)",
			attributes: [
				NSForegroundColorAttributeName: NSColor.lightGrayColor(),
			]
		)
	}

	func appendPrototypeChangedMessage(url: NSURL) {
		appendMessage(
			"(switching prototype to \(url.filePathURL!.path!))",
			attributes: [
				NSForegroundColorAttributeName: NSColor.lightGrayColor(),
			]
		)
	}

	private func appendMessage(message: String, var attributes: [String: AnyObject]) {
		attributes[NSFontAttributeName] = LogViewController.font
		logTextView.textStorage!.appendAttributedString(NSAttributedString(
			string: "\(message)\n",
			attributes: attributes
		))

		logTextView.moveToEndOfDocument(nil)
	}

	@IBAction func clear(sender: AnyObject) {
		logTextView.textStorage!.deleteCharactersInRange(NSMakeRange(0, logTextView.textStorage!.length))
	}

	@IBOutlet var logTextView: NSTextView!

	private static var font = NSFont(name: "Menlo", size: 14)!
}
