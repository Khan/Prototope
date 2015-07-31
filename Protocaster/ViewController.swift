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
let LastSelectedPathURLKey = "LastSelectedPathURLKey"

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
    
    var lastSelectedPathURL: NSURL? {
        get {
            return NSUserDefaults.standardUserDefaults().URLForKey(LastSelectedPathURLKey)
        }
        
        set {
            if let URL = newValue {
                NSUserDefaults.standardUserDefaults().setURL(URL, forKey: LastSelectedPathURLKey)
            } else {
                NSUserDefaults.standardUserDefaults().setNilValueForKey(LastSelectedPathURLKey)
            }
        }
    }

    @IBOutlet weak var pathControl: NSPathControl!
	@IBOutlet var deviceListController: NSArrayController!
	@IBOutlet weak var deviceChooserButton: NSPopUpButton!
	@IBOutlet weak var deviceSettingsCheckbox: NSButton!
    
    override func awakeFromNib() {
        pathControl.URL = lastSelectedPathURL
    }

	@IBAction func pathControlDidChange(sender: NSPathControl) {
		selectedPathDidChange?(sender.URL)
        if let URL = sender.URL {
            lastSelectedPathURL = URL
        }
	}

	@IBAction func deviceSelectionDidChange(sender: NSPopUpButton) {
		let service = sender.selectedItem?.representedObject as! NSNetService?
		toggleCheckboxForService(service)
		selectedDeviceDidChange?(service)
	}

	func addService(service: NSNetService) {
		deviceListController.addObject(service)
		if service.name == lastSelectedDeviceName {
			selectedDeviceDidChange?(service)
			deviceChooserButton.selectItemWithTitle(service.name)
		}
		toggleCheckboxForService(service)
	}
	
	
	func toggleCheckboxForService(service: NSNetService?) {
		let currentlySelectedDeviceName = self.deviceChooserButton.selectedItem?.title
		let serviceName = service?.name
		if currentlySelectedDeviceName != serviceName {
			return // we don't care!
		}
		
		if serviceName == lastSelectedDeviceName {
			deviceSettingsCheckbox.state = NSOnState
		} else {
			deviceSettingsCheckbox.state = NSOffState
		}
	}

	func removeService(service: NSNetService) {
		deviceListController.removeObject(service)
	}
	
	@IBAction func checkboxDidChange(sender: NSButton) {
		let currentlySelectedDeviceName = self.deviceChooserButton.selectedItem?.title
		
		if sender.state == NSOnState {
			self.lastSelectedDeviceName = currentlySelectedDeviceName
		} else if self.lastSelectedDeviceName == currentlySelectedDeviceName {
			// We've unchecked saving the current device, so forget its name
			self.lastSelectedDeviceName = nil
		}
	}
}

