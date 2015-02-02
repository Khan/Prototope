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
    init(red: Double, green: Double, blue: Double, alpha: JSValue?)
}

@objc public class ColorBridge: NSObject, ColorJSExport, BridgeType {
    
    public class func addToContext(context: JSContext) {
        context.setObject(self, forKeyedSubscript: "Color")
    }
    
    let color: Color
    
    required public init(red: Double, green: Double, blue: Double, alpha: JSValue?) {
        var alpha: Double = Double(alpha?.toNumber() ?? 1.0)
        color = Color(red: red, green: green, blue: blue, alpha: alpha)
        super.init()
    }
    
    init(_ color: Color) {
        self.color = color
    }
}
