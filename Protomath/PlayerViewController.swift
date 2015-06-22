//
//  PlayerViewController.swift
//  Prototope
//
//  Created by Jason Brennan on 2015-06-22.
//  Copyright (c) 2015 Khan Academy. All rights reserved.
//

import UIKit
import Prototope
import PrototopeJSBridge


class PlayerViewController: UIViewController {
	var context: Context!
	let jsPath: NSURL
	
	init(path: NSURL) {
		self.jsPath = path
		super.init(nibName: nil, bundle: nil)
	}
	
	required init(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = UIColor.whiteColor()
		Environment.currentEnvironment = Environment.defaultEnvironmentWithRootView(view)

		runJSPrototope()
	}

	
	func runJSPrototope() {
		
		context = Context()
		context.exceptionHandler = { value in
			let lineNumber = value.objectForKeyedSubscript("line")
			println("Exception on line \(lineNumber): \(value)")
		}
		context.consoleLogHandler = { message in
			println(message)
		}
		
		let script = NSString(contentsOfURL: self.jsPath, encoding: NSUTF8StringEncoding, error: nil)!
		context.evaluateScript(script as String)
	}
	
	
	func handleKeyCommand(command: UIKeyCommand!) {
		switch command.input {
		case UIKeyInputEscape:
			self.navigationController?.popToRootViewControllerAnimated(true)
		default:
			return
		}
	}
	
	// needed to let vc handle keypresses
	override func canBecomeFirstResponder() -> Bool {
		return true
	}
	
	override var keyCommands: [AnyObject]? {
		get {
			let escape = UIKeyCommand(input: UIKeyInputEscape, modifierFlags: nil, action: "handleKeyCommand:")
			return [escape]
		}
	}

}