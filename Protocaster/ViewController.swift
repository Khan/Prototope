//
//  ViewController.swift
//  Protocaster
//
//  Created by Andy Matuschak on 2/6/15.
//  Copyright (c) 2015 Khan Academy. All rights reserved.
//

import Cocoa
import swiftz_core

class ViewController: NSViewController {

	var selectedPathDidChange: (NSURL? -> ())?
	var selectedDeviceDidChange: (NSNetService? -> ())?

	var selectedDeviceSession: NSNetService?

	@IBOutlet var deviceListController: NSArrayController!
	@IBOutlet weak var deviceChooserButton: NSPopUpButton!

	@IBAction func pathControlDidChange(sender: NSPathControl) {
		selectedPathDidChange?(sender.URL)
	}

	@IBAction func deviceSelectionDidChange(sender: NSPopUpButton) {
		selectedDeviceDidChange?(sender.selectedItem?.representedObject as! NSNetService?)
	}

	func addService(service: NSNetService) {
		deviceListController.addObject(service)
	}

	func removeService(service: NSNetService) {
		deviceListController.removeObject(service)
	}
	
}

