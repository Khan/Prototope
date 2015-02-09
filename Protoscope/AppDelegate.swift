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

	var rootViewController: RootViewController!
	var server: ProtoscopeServer!
	var sessionInteractor: SessionInteractor!

	func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
		UIApplication.sharedApplication().idleTimerDisabled = true

		rootViewController = RootViewController()
		window = UIWindow(frame: UIScreen.mainScreen().bounds)
		window.rootViewController = rootViewController
		window.makeKeyAndVisible()

		self.sessionInteractor = SessionInteractor()

		server = ProtoscopeServer(messageHandler: {
			switch $0 {
			case let .ReplacePrototype(prototype):
				let script = NSString(data: prototype.mainScript, encoding: NSUTF8StringEncoding)!
				let sceneDisplayHostView = self.rootViewController.transitionToSceneDisplay()
				self.sessionInteractor.displayScene(script, rootView: sceneDisplayHostView)
			}
		})
		
		return true
	}


}
