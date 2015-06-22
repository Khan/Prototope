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
		let defaultEnvironment = Environment.defaultEnvironmentWithRootView(self.view)
		
		let imageProvider = { 
			(name: String) -> UIImage? in
			let scale = UIScreen.mainScreen().scale
			let filenameWithScale = name.stringByAppendingString("@\(Int(scale))x").stringByAppendingPathExtension("png")!
			let filename = name.stringByAppendingPathExtension("png")!
			
			let path = self.jsPath.URLByDeletingLastPathComponent!
			let scalePath = path.URLByAppendingPathComponent(filenameWithScale)
			let noScalePath = path.URLByAppendingPathComponent(filename)
			
			let loadImage: (String) -> UIImage? = { path in
				let image = UIImage(contentsOfFile: path)
				return image
			}
			
			return loadImage(scalePath.path!) ?? loadImage(noScalePath.path!)
		}
		
		Environment.currentEnvironment = Environment(rootView: view, imageProvider: imageProvider, soundProvider: defaultEnvironment.soundProvider, fontProvider: defaultEnvironment.fontProvider, exceptionHandler: defaultEnvironment.exceptionHandler)

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