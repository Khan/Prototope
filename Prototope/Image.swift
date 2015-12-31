//
//  Image.swift
//  Prototope
//
//  Created by Andy Matuschak on 10/16/14.
//  Copyright (c) 2014 Khan Academy. All rights reserved.
//

#if os(iOS)
	import UIKit
	public typealias SystemImage = UIImage
	#else
	import AppKit
	
	public typealias SystemImage = NSImage
	extension SystemImage {
		var CGImage: CGImageRef {
			var rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
			return self.CGImageForProposedRect(&rect, context: nil, hints: nil)!.takeUnretainedValue()
		}
	}
#endif


/** A simple abstraction for a bitmap image. */
public struct Image: Printable {
	

	/** The size of the image, in points. */
	public var size: Size {
		return Size(systemImage.size)
	}

	public var name: String!

	var systemImage: SystemImage

	/** Loads a named image from the assets built into the app. */
	public init?(name: String) {
		if let image = Environment.currentEnvironment!.imageProvider(name) {
			systemImage = image
			self.name = name
		} else {
			Environment.currentEnvironment?.exceptionHandler("Image named \(name) not found")
			return nil
		}
	}

	/** Constructs an Image from a UIImage. */
	init(_ image: SystemImage) {
		systemImage = image
	}
	
	
	public var description: String {
		return self.name
	}
}
