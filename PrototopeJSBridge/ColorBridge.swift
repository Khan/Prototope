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
    init(red: Double, green: Double, blue: Double, alpha: Double)
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
    
    let color: Color
    
    required public init(red: Double, green: Double, blue: Double, alpha: Double) {
        color = Color(red: red, green: green, blue: blue, alpha: alpha)
        super.init()
    }
    
    init(_ color: Color) {
        self.color = color
    }

}
