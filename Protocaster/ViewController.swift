//
//  ViewController.swift
//  Protocaster
//
//  Created by Andy Matuschak on 2/6/15.
//  Copyright (c) 2015 Khan Academy. All rights reserved.
//

import Cocoa
import swiftz_core

let LastSelectedDeviceNameKey = "LastSelectedDeviceNameKey"
class ViewController: NSViewController {

	var selectedPathDidChange: (NSURL? -> ())?
	var selectedDeviceDidChange: (NSNetService? -> ())?

	var selectedDeviceSession: NSNetService?
	
	var lastSelectedDeviceName: NSString? {
		get {
			return NSUserDefaults.standardUserDefaults().stringForKey(LastSelectedDeviceNameKey)
		}
		
		set {
			NSUserDefaults.standardUserDefaults().setObject(newValue, forKey: LastSelectedDeviceNameKey)
		}
	}

	@IBOutlet var deviceListController: NSArrayController!
	@IBOutlet weak var deviceChooserButton: NSPopUpButton!

	@IBAction func pathControlDidChange(sender: NSPathControl) {
		selectedPathDidChange?(sender.URL)
	}

	@IBAction func deviceSelectionDidChange(sender: NSPopUpButton) {
		let service = sender.selectedItem?.representedObject as! NSNetService?
		lastSelectedDeviceName = service?.name
		selectedDeviceDidChange?(service)
	}

	func addService(service: NSNetService) {
		deviceListController.addObject(service)
		if service.name == lastSelectedDeviceName {
			selectedDeviceDidChange?(service)
			deviceChooserButton.selectItemWithTitle(service.name)
		}
	}

	func removeService(service: NSNetService) {
		deviceListController.removeObject(service)
	}
	
}

