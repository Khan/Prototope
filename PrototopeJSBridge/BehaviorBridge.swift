//
//  BehaviorBridge.swift
//  Prototope
//
//  Created by Saniul Ahmed on 11/02/2015.
//  Copyright (c) 2015 Khan Academy. All rights reserved.
//

import Foundation
import JavaScriptCore
import Prototope

func behaviorBridgeForBehavior(behavior: BehaviorType) -> BehaviorBridgeType {
    switch behavior {
    case is CollisionBehavior: return CollisionBehaviorBridge(behavior as! CollisionBehavior)
    case is ActionBehavior: return ActionBehaviorBridge(behavior as! ActionBehavior)
        
    default: abort()
    }
}

func behaviorForBehaviorBridge(behaviorBridge: BehaviorBridgeType) -> BehaviorType {
    switch behaviorBridge {
    case is CollisionBehaviorBridge: return (behaviorBridge as! CollisionBehaviorBridge).collisionBehavior
    case is ActionBehaviorBridge: return (behaviorBridge as! ActionBehaviorBridge).actionBehavior
    default: abort()
    }
}

@objc public protocol BehaviorBridgeType {
}

@objc public protocol CollisionBehaviorJSExport: JSExport {
    init?(args: JSValue)
}

//MARK: CollisionBehavior

@objc public class CollisionBehaviorBridge: NSObject, BridgeType, BehaviorBridgeType, CollisionBehaviorJSExport {
    let collisionBehavior: Prototope.CollisionBehavior!
    
    public class func addToContext(context: JSContext) {
        context.setObject(self, forKeyedSubscript: "CollisionBehavior")
    }
    
    public init(_ behavior: CollisionBehavior) {
        self.collisionBehavior = behavior
        super.init()
    }
    
    required public init?(args: JSValue) {
        let otherLayerValue = args.valueForProperty("with")
        let handler = args.valueForProperty("handler")
        
        if let otherLayer = (otherLayerValue.toObject() as? JSExport as? LayerBridge)?.layer where !otherLayerValue.isUndefined,
            let handler = handler where !handler.isUndefined {
                collisionBehavior = CollisionBehavior(with: otherLayer, handler: { kind in
                    let bridgedKind = CollisionBehaviorKindBridge.encodeKind(kind, inContext: handler.context)
                    handler.callWithArguments([bridgedKind])
                })
                super.init()
        } else {
            collisionBehavior = nil
            super.init()
            return nil
        }
    }
}

// MARK: CollisionBehavior.Kind

public class CollisionBehaviorKindBridge: NSObject, BridgeType {
    enum RawKind: Int {
        case Entering = 0
        case Leaving
    }
    
    public class func addToContext(context: JSContext) {
        let kindObject = JSValue(newObjectInContext: context)
        kindObject.setObject(RawKind.Entering.rawValue, forKeyedSubscript: "Entering")
        kindObject.setObject(RawKind.Leaving.rawValue, forKeyedSubscript: "Leaving")
        context.setObject(kindObject, forKeyedSubscript: "CollisionBehaviorKind")
    }
    
    public class func encodeKind(kind: Prototope.CollisionBehavior.Kind, inContext context: JSContext) -> JSValue {
        var rawKind: RawKind
        switch kind {
        case .Entering: rawKind = .Entering
        case .Leaving: rawKind = .Leaving
        }
        return JSValue(int32: Int32(rawKind.rawValue), inContext: context)
    }
    
    public class func decodeKind(bridgedKind: JSValue) -> Prototope.CollisionBehavior.Kind? {
        if let rawKind = RawKind(rawValue: Int(bridgedKind.toInt32())) {
            switch rawKind {
            case .Entering: return .Entering
            case .Leaving: return .Leaving
            }
        } else {
            return nil
        }
    }
}

// MARK: ActionBehavior

@objc public protocol ActionBehaviorJSExport: JSExport {
    init?(args: JSValue)
}


@objc public class ActionBehaviorBridge: NSObject, BridgeType, BehaviorBridgeType, ActionBehaviorJSExport {
    let actionBehavior: Prototope.ActionBehavior!
    
    public class func addToContext(context: JSContext) {
        context.setObject(self, forKeyedSubscript: "ActionBehavior")
    }
    
    public init(_ behavior: ActionBehavior) {
        self.actionBehavior = behavior
        super.init()
    }
    
    required public init?(args: JSValue) {
        let handler = args.objectForKeyedSubscript("handler")
        
        if let handler = handler where !handler.isUndefined {
            actionBehavior = ActionBehavior { layer in
                handler.callWithArguments([LayerBridge(layer)!])
            }
            super.init()
        } else {
            actionBehavior = nil
            super.init()
            return nil
        }
    }
}

