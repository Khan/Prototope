//
//  FontProvider.swift
//  Prototope
//
//  Created by Saniul Ahmed on 15/06/2015.
//  Copyright © 2015 Khan Academy. All rights reserved.
//

import Foundation

public class FontProvider {
	static private let supportedExtensions = ["ttf", "otf"]
	
	let resources: [String : NSData]
	
	var registeredFontsURLs = [NSURL]()
	
	public init(resources: [String : NSData]) {
		self.resources = resources
	}
	
	deinit {
		for URL in registeredFontsURLs {
			var fontError: Unmanaged<CFError>?
			if CTFontManagerUnregisterFontsForURL(URL, CTFontManagerScope.Process, &fontError) {
				println("Successfully unloaded font: '\(URL)'.")
			} else if let fontError = fontError?.takeRetainedValue() {
				let errorDescription = CFErrorCopyDescription(fontError)
				println("Failed to unload font '\(URL)': \(errorDescription)")
			} else {
				println("Failed to unload font '\(URL)'.")
			}
		}
	}
	
	func resourceForFontWithName(name: String) -> NSData? {
		for fileExtension in FontProvider.supportedExtensions {
			if let data = resources[name.stringByAppendingPathExtension(fileExtension)!] {
				return data
			}
		}
		
		return nil
	}
	
	public func fontForName(name: String, size: Double) -> UIFont? {
		if let font = UIFont(name: name, size: CGFloat(size)) {
			return font
		}
		
		if let customFontData = resourceForFontWithName(name) {
			let URL = NSFileManager.defaultManager().URLsForDirectory(NSSearchPathDirectory.CachesDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask).first as! NSURL
			
			let fontFileURL = URL.URLByAppendingPathComponent(name)
			
			customFontData.writeToURL(fontFileURL, atomically: true)
			
			var fontError: Unmanaged<CFError>?
			if CTFontManagerRegisterFontsForURL(fontFileURL, CTFontManagerScope.Process, &fontError) {
				registeredFontsURLs += [fontFileURL]
				
				println("Successfully loaded font: '\(name)'.")
				if let font = UIFont(name: name, size: CGFloat(size)) {
					return font
				}
			} else if let fontError = fontError?.takeRetainedValue() {
				let errorDescription = CFErrorCopyDescription(fontError)
				println("Failed to load font '\(name)': \(errorDescription)")
			} else {
				println("Failed to load font '\(name)'.")
			}
		}
		
		return nil
	}
}