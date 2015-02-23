//
//  ColorBridge.swift
//  Prototope
//
//  Created by Andy Matuschak on 2/1/15.
//  Copyright (c) 2015 Khan Academy. All rights reserved.
//

import Foundation
import Prototope
import JavaScriptCore

@objc public protocol ColorJSExport: JSExport {
	init?(args: NSDictionary)
}

@objc public class ColorBridge: NSObject, ColorJSExport, BridgeType {
    
    public class func addToContext(context: JSContext) {
        context.setObject(self, forKeyedSubscript: "Color")
		let colorBridge = context.objectForKeyedSubscript("Color")
		colorBridge.setObject(ColorBridge(Color.black), forKeyedSubscript: "black")
		colorBridge.setObject(ColorBridge(Color.darkGray), forKeyedSubscript: "darkGray")
		colorBridge.setObject(ColorBridge(Color.lightGray), forKeyedSubscript: "lightGray")
		colorBridge.setObject(ColorBridge(Color.white), forKeyedSubscript: "white")
		colorBridge.setObject(ColorBridge(Color.gray), forKeyedSubscript: "gray")
		colorBridge.setObject(ColorBridge(Color.red), forKeyedSubscript: "red")
		colorBridge.setObject(ColorBridge(Color.green), forKeyedSubscript: "green")
		colorBridge.setObject(ColorBridge(Color.blue), forKeyedSubscript: "blue")
		colorBridge.setObject(ColorBridge(Color.cyan), forKeyedSubscript: "cyan")
		colorBridge.setObject(ColorBridge(Color.yellow), forKeyedSubscript: "yellow")
		colorBridge.setObject(ColorBridge(Color.magenta), forKeyedSubscript: "magenta")
		colorBridge.setObject(ColorBridge(Color.orange), forKeyedSubscript: "orange")
		colorBridge.setObject(ColorBridge(Color.purple), forKeyedSubscript: "purple")
		colorBridge.setObject(ColorBridge(Color.brown), forKeyedSubscript: "brown")
		colorBridge.setObject(ColorBridge(Color.clear), forKeyedSubscript: "clear")
    }
    
    let color: Color!
    
    required public init?(args: NSDictionary) {
    	let alpha = (args["alpha"] as! Double?) ?? 1
    	if let hue = args["hue"] as! Double? {
    		if let saturation = args["saturation"] as! Double? {
    			if let brightness = args["brightness"] as! Double? {
    				color = Color(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
    			} else {
					color = nil
					super.init()
					return nil
				}
    		} else {
				color = nil
				super.init()
				return nil
			}
    	} else if let white = args["white"] as! Double? {
    		color = Color(white: white, alpha: alpha)
    	} else if let hexString = args["hex"] as! String? {
    		let scanner = NSScanner(string: hexString)
			var hex: UInt32 = 0
			if scanner.scanHexInt(&hex) {
				color = Color(hex: hex, alpha: alpha)
			} else {
				color = nil
				super.init()
				return nil
			}
    	} else {
	        color = Color(
				red: (args["red"] as! Double?) ?? 0,
				green: (args["green"] as! Double?) ?? 0,
				blue: (args["blue"] as! Double?) ?? 0,
				alpha: (args["alpha"] as! Double?) ?? 1
			)
	    }
		super.init()
    }
    
    init(_ color: Color) {
        self.color = color
    }

}
