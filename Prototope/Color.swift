//
//  Color.swift
//  Prototope
//
//  Created by Andy Matuschak on 10/7/14.
//  Copyright (c) 2014 Khan Academy. All rights reserved.
//

#if os(iOS)
	import UIKit
	typealias SystemColor = UIColor
#else
	import AppKit
	typealias SystemColor = NSColor
#endif


/** A simple representation of color. */
public struct Color {
	let systemColor: SystemColor
	
	/** The underlying CGColor of this colour. */
	var CGColor: CGColorRef {
		return self.systemColor.CGColor
	}

	/** Constructs a color from RGB and alpha values. Arguments range from 0.0 to 1.0. */
	public init(red: Double, green: Double, blue: Double, alpha: Double = 1.0) {
		systemColor = SystemColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: CGFloat(alpha))
	}

	/** Constructs a grayscale color. Arguments range from 0.0 to 1.0.  */
	public init(white: Double, alpha: Double = 1.0) {
		systemColor = SystemColor(white: CGFloat(white), alpha: CGFloat(alpha))
	}

	/** Constructs a color from HSB and alpha values. Arguments range from 0.0 to 1.0. */
	public init(hue: Double, saturation: Double, brightness: Double, alpha: Double = 1.0) {
		systemColor = SystemColor(hue: CGFloat(hue), saturation: CGFloat(saturation), brightness: CGFloat(brightness), alpha: CGFloat(alpha))
	}

	/** Construct a color from a hex value and with alpha from 0.0 - 1.0.
		i.e. Color(hex: 0x336699, alpha: 0.2)
	 */
	public init(hex: UInt32, alpha: Double) {
	    var r = CGFloat((hex >> 16) & 0xff) / 255.0
	    var g = CGFloat((hex >> 8) & 0xff) / 255.0
	    var b = CGFloat(hex & 0xff) / 255.0
	    systemColor = SystemColor(red: CGFloat(r), green: CGFloat(g), blue: CGFloat(b), alpha: CGFloat(alpha))
	}

	/** Construct an opaque color from a hex value
		i.e. Color(hex: 0x336699)
	 */
	public init(hex: UInt32) {
		self.init(hex: hex, alpha: 1.0)
	}

	/** Constructs a Color from a UIColor. */
	init(_ systemColor: SystemColor) {
		self.systemColor = systemColor
	}

	public static var black: Color { return Color(SystemColor.blackColor()) }
	public static var darkGray: Color { return Color(SystemColor.darkGrayColor()) }
	public static var lightGray: Color { return Color(SystemColor.lightGrayColor()) }
	public static var white: Color { return Color(SystemColor.whiteColor()) }
	public static var gray: Color { return Color(SystemColor.grayColor()) }
	public static var red: Color { return Color(SystemColor.redColor()) }
	public static var green: Color { return Color(SystemColor.greenColor()) }
	public static var blue: Color { return Color(SystemColor.blueColor()) }
	public static var cyan: Color { return Color(SystemColor.cyanColor()) }
	public static var yellow: Color { return Color(SystemColor.yellowColor()) }
	public static var magenta: Color { return Color(SystemColor.magentaColor()) }
	public static var orange: Color { return Color(SystemColor.orangeColor()) }
	public static var purple: Color { return Color(SystemColor.purpleColor()) }
	public static var brown: Color { return Color(SystemColor.brownColor()) }
	public static var clear: Color { return Color(SystemColor.clearColor()) }
}
