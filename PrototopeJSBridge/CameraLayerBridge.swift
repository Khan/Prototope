//
//  CameraLayerBridge.swift
//  Prototope
//
//  Created by Andy Matuschak on 2/15/15.
//  Copyright (c) 2015 Khan Academy. All rights reserved.
//

import Foundation
import Prototope
import JavaScriptCore

@objc public protocol CameraLayerJSExport: JSExport {
	var cameraPosition: JSValue { get set }
}

@objc public class CameraLayerBridge: LayerBridge, CameraLayerJSExport, BridgeType {
	var cameraLayer: CameraLayer { return layer as! CameraLayer }

	public override class func bridgedPrototypeInContext(context: JSContext) -> JSValue { return JSValue(object: self, inContext: context) }
	public static var bridgedConstructorName: String = "CameraLayer"

	public required init?(args: NSDictionary) {
		let parentLayer = (args["parent"] as! LayerBridge?)?.layer
		let cameraLayer = CameraLayer(parent: parentLayer, name: (args["name"] as! String?))
		super.init(cameraLayer)
	}

	public var cameraPosition: JSValue {
		get { return CameraPositionBridge.encodeCameraPosition(cameraLayer.cameraPosition, inContext: JSContext.currentContext()) }
		set { cameraLayer.cameraPosition = CameraPositionBridge.decodeCameraPosition(newValue) }
	}
	
}

public class CameraPositionBridge: NSObject, BridgeType {
	enum RawCameraPosition: Int {
		case Front = 0
		case Back = 1
	}

	public class func bridgedPrototypeInContext(context: JSContext) -> JSValue {
		let alignmentObject = JSValue(newObjectInContext: context)
		alignmentObject.setObject(RawCameraPosition.Front.rawValue, forKeyedSubscript: "Front")
		alignmentObject.setObject(RawCameraPosition.Back.rawValue, forKeyedSubscript: "Back")
		return alignmentObject
	}

	public static var bridgedConstructorName: String = "CameraPosition"

	public class func encodeCameraPosition(cameraPosition: Prototope.CameraLayer.CameraPosition, inContext context: JSContext) -> JSValue {
		var rawCameraPosition: RawCameraPosition
		switch cameraPosition {
		case .Front: rawCameraPosition = .Front
		case .Back: rawCameraPosition = .Back
		}
		return JSValue(int32: Int32(rawCameraPosition.rawValue), inContext: context)
	}
	
	public class func decodeCameraPosition(bridgedCameraPosition: JSValue) -> Prototope.CameraLayer.CameraPosition! {
		if let rawCameraPosition = RawCameraPosition(rawValue: Int(bridgedCameraPosition.toInt32())) {
			switch rawCameraPosition {
			case .Front: return .Front
			case .Back: return .Back
			}
		} else {
			Environment.currentEnvironment!.exceptionHandler("Unknown camera position: \(bridgedCameraPosition)")
			return nil
		}
	}
}

