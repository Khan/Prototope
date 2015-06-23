//
//  PrototypeProvider.swift
//  Prototope
//
//  Created by Jason Brennan on 2015-06-22.
//  Copyright (c) 2015 Khan Academy. All rights reserved.
//

import Foundation


/** Provides Prototype objects loaded from the application's bundle. */
struct PrototypeProvider {
	
	private static let prototypeDirectory = "Early-Math-Prototypes"
	let prototypes: [Prototype]
	
	init() {
		if let resourcePath = NSBundle.mainBundle().resourcePath {
			let earlyMathPath = resourcePath + "/" + PrototypeProvider.prototypeDirectory
			let fileManager = NSFileManager.defaultManager()
			var errorPtr = NSErrorPointer()
			let files = fileManager.contentsOfDirectoryAtPath(earlyMathPath, error: errorPtr) as! [String]
			let filtered = files.filter {
				var isDirectory: ObjCBool = ObjCBool(false)
				if fileManager.fileExistsAtPath(earlyMathPath + "/" + $0, isDirectory: &isDirectory) {
					return isDirectory.boolValue
				}
				return false
			}
			self.prototypes = filtered.map {
				Prototype(directoryURL: NSURL(fileURLWithPath: earlyMathPath + "/" + $0, isDirectory: true)!, name: $0)!
			}
		} else {
			self.prototypes = []
		}
		
	}
}


/** Prototype..er, type. Represents a prototype directory on disk with reference to the main javascript file. Derived from Protorope.Prototype. */
struct Prototype {
	let mainFileURL: NSURL
	let name: String
}


extension Prototype {
	init?(directoryURL: NSURL, name: String) {
		
		if !directoryURL.fileURL { return nil }
		
		var error: NSError? = nil
		let path = directoryURL.filePathURL!.path!
		
		var isDirectory: ObjCBool = ObjCBool(false)
		let exists = NSFileManager.defaultManager().fileExistsAtPath(path, isDirectory: &isDirectory)
		if !exists {
			println("File does not exist: \(path)")
			return nil
		}
		
		var mainScriptPath: String

		if isDirectory.boolValue {
			var error: NSError? = nil
			let contents = NSFileManager.defaultManager().contentsOfDirectoryAtPath(path, error: &error) as! [String]?
			if contents == nil {
				println("Couldn't read directory \(path): \(error)")
				return nil
			}
			
			let javaScriptFiles = contents!.filter { $0.pathExtension == "js" }
			switch javaScriptFiles.count {
			case 0:
				println("No JavaScript files found in \(path)")
				return nil
			case 1:
				mainScriptPath = path.stringByAppendingPathComponent(javaScriptFiles.first!)
			default:
				println("Multiple JavaScript files found in \(path): \(javaScriptFiles)")
				return nil
			}
		} else {
			mainScriptPath = path
		}
		
		self.name = name
		self.mainFileURL = NSURL(fileURLWithPath: mainScriptPath)!
	}
}

