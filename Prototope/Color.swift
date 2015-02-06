//
//  Color.swift
//  Prototope
//
//  Created by Andy Matuschak on 10/7/14.
//  Copyright (c) 2014 Khan Academy. All rights reserved.
//

import UIKit

/** A simple representation of color. */
public struct Color {
	let uiColor: UIColor
	
	/** The underlying CGColor of this colour. */
	var CGColor: CGColorRef {
		return self.uiColor.CGColor
	}

	/** Constructs a color from RGB and alpha values. Arguments range from 0.0 to 1.0. */
	public init(red: Double, green: Double, blue: Double, alpha: Double = 1.0) {
		uiColor = UIColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: CGFloat(alpha))
	}

	/** Constructs a grayscale color. Arguments range from 0.0 to 1.0.  */
	public init(white: Double, alpha: Double = 1.0) {
		uiColor = UIColor(white: CGFloat(white), alpha: CGFloat(alpha))
	}

	/** Constructs a color from HSB and alpha values. Arguments range from 0.0 to 1.0. */
	public init(hue: Double, saturation: Double, brightness: Double, alpha: Double = 1.0) {
		uiColor = UIColor(hue: CGFloat(hue), saturation: CGFloat(saturation), brightness: CGFloat(brightness), alpha: CGFloat(alpha))
	}

	/** Construct a color from a hex value and with alpha from 0.0 - 1.0.
		i.e. Color(hex: 0x336699, alpha: 0.2)
	 */
	public init(hex: UInt32, alpha: Double) {
	    var r = CGFloat((hex >> 16) & 0xff) / 255.0
	    var g = CGFloat((hex >> 8) & 0xff) / 255.0
	    var b = CGFloat(hex & 0xff) / 255.0
	    uiColor = UIColor(red: CGFloat(r), green: CGFloat(g), blue: CGFloat(b), alpha: CGFloat(alpha))
	}

	/** Construct an opaque color from a hex value
		i.e. Color(hex: 0x336699)
	 */
	public init(hex: UInt32) {
		self.init(hex: hex, alpha: 1.0)
	}

	/** Constructs a Color from a UIColor. */
	init(_ uiColor: UIColor) {
		self.uiColor = uiColor
	}

	public static var black: Color { return Color(UIColor.blackColor()) }
	public static var darkGray: Color { return Color(UIColor.darkGrayColor()) }
	public static var lightGray: Color { return Color(UIColor.lightGrayColor()) }
	public static var white: Color { return Color(UIColor.whiteColor()) }
	public static var gray: Color { return Color(UIColor.grayColor()) }
	public static var red: Color { return Color(UIColor.redColor()) }
	public static var green: Color { return Color(UIColor.greenColor()) }
	public static var blue: Color { return Color(UIColor.blueColor()) }
	public static var cyan: Color { return Color(UIColor.cyanColor()) }
	public static var yellow: Color { return Color(UIColor.yellowColor()) }
	public static var magenta: Color { return Color(UIColor.magentaColor()) }
	public static var orange: Color { return Color(UIColor.orangeColor()) }
	public static var purple: Color { return Color(UIColor.purpleColor()) }
	public static var brown: Color { return Color(UIColor.brownColor()) }
	public static var clear: Color { return Color(UIColor.clearColor()) }
}
