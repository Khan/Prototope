//
//  AppDelegate.swift
//  Protomath
//
//  Created by Jason Brennan on 2015-06-22.
//  Copyright (c) 2015 Khan Academy. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?
	var rootViewController: ViewController!
	var navigationController: UINavigationController!


	func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
		
		application.idleTimerDisabled = true
		
		rootViewController = ViewController(style: .Plain)
		
		navigationController = UINavigationController(rootViewController: rootViewController)
		navigationController.navigationBarHidden = true
		

		window?.rootViewController = navigationController
		
		return true
	}


}

