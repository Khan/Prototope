//
//  Image.swift
//  Prototope
//
//  Created by Andy Matuschak on 10/16/14.
//  Copyright (c) 2014 Khan Academy. All rights reserved.
//

import UIKit

public struct Image {
	public init!(name: String) {
		if let image = UIImage(named: name) {
			uiImage = image
		} else {
			fatalError("Image named \(name) not found")
			return nil
		}
	}

	init(_ image: UIImage) {
		uiImage = image
	}

	public var size: Size {
		return Size(uiImage.size)
	}

	var uiImage: UIImage
}
