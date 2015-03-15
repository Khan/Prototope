//
//  Image.swift
//  Prototope
//
//  Created by Andy Matuschak on 10/16/14.
//  Copyright (c) 2014 Khan Academy. All rights reserved.
//

import UIKit

/** A simple abstraction for a bitmap image. */
public struct Image {
	/** The size of the image, in points. */
	public var size: Size {
		return Size(uiImage.size)
	}

	public var name: String!

	var uiImage: UIImage

	/** Loads a named image from the assets built into the app. */
	public init?(name: String) {
		if let image = Environment.currentEnvironment!.imageProvider(name) {
			uiImage = image
			self.name = name
		} else {
			Environment.currentEnvironment?.exceptionHandler("Image named \(name) not found")
			return nil
		}
	}

	/** Constructs an Image from a UIImage. */
	init(_ image: UIImage) {
		uiImage = image
	}
}
