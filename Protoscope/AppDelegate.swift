//
//  AppDelegate.swift
//  Protoscope
//
//  Created by Andy Matuschak on 2/6/15.
//  Copyright (c) 2015 Khan Academy. All rights reserved.
//

import UIKit
import Prototope
import PrototopeJSBridge

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
	var window: UIWindow!
	var server: ProtoscopeServer!
	var context: Context!

	func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
		UIApplication.sharedApplication().idleTimerDisabled = true

		window = UIWindow(frame: UIScreen.mainScreen().bounds)
		window.makeKeyAndVisible()
		window.rootViewController = RootViewController()

		Prototope.Layer.setRoot(fromView: self.window!)

		server = ProtoscopeServer(messageHandler: {
			let script = NSString(data: $0 as NSData, encoding: NSUTF8StringEncoding)
			println(script)
			Prototope.Layer.root?.removeAllSublayers()

			self.context = PrototopeJSBridge.Context()
			self.context.exceptionHandler = { value in
				let lineNumber = value.objectForKeyedSubscript("line")
				println("Exception on line \(lineNumber): \(value)")
			}
			self.context.evaluateScript(script)
		})
		return true
	}


}
