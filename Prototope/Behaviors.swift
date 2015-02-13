//
//  Collisions.swift
//  Prototope
//
//  Created by Saniul Ahmed on 07/02/2015.
//  Copyright (c) 2015 Khan Academy. All rights reserved.
//

import Foundation

//MARK: Public Behavior Types

/** Protocol for types describing the "configuration" of a behavior. */
public protocol BehaviorType {}

/** Describes a behavior that just calls a closure/block on every heartbeat,
    passing the host layer to the closure. */
public struct ActionBehavior: BehaviorType {
    let handler: Layer -> Void
    
    public init(handler: Layer->Void) {
        self.handler = handler
    }
}

/** Value type describing the configuration of a collision behavior, specifying
 the kind of the interaction (the collision conditions which should trigger the handler)
 the layer with which the host layer is supposed to be colliding and a handler function */
public struct CollisionBehavior: BehaviorType {
    public enum Kind {
        case Entering
        case Leaving
    }
    
    let kind: Kind
    let otherLayer: Layer
    let handler: () -> Void
    
    public init(on kind: Kind, _ otherLayer: Layer, handler: ()->Void) {
        self.kind = kind
        self.otherLayer = otherLayer
        self.handler = handler
    }
}

//MARK: Behavior Bindings

/** Abstract. Describes a relationship between a layer and a single instance of a behavior.
 Subclasses should encapsulate the state necessary to handle the behavior correctly. */
class BehaviorBinding: Equatable, Hashable {
    let id: Int
    let hostLayer: Layer
    
    static var behaviorCounter = 0
    
    init(hostLayer: Layer) {
        self.id = BehaviorBinding.behaviorCounter++
        self.hostLayer = hostLayer
    }
    
    func update() {
        fatalError("BehaviorBinding.update must be overridden")
    }
    
    var hashValue: Int {
        return id
    }
}

func ==(b1: BehaviorBinding, b2: BehaviorBinding) -> Bool {
    return b1.id == b2.id
}

/** Possible collision states for a pair of layers */
enum CollisionState {
    case NonOverlapping
    case PartiallyIntersects
    case ContainedIn
    case Contains
    
    static func stateForLayer(layer1: Layer, andLayer layer2: Layer) -> CollisionState {
        let rect1 = Layer.root.view.convertRect(CGRect(layer1.frame), fromView:layer1.view.superview)
        let rect2 = Layer.root.view.convertRect(CGRect(layer2.frame), fromView:layer2.view.superview)
        
        if !CGRectIntersectsRect(rect1, rect2) {
            return .NonOverlapping
        }
        
        if CGRectContainsRect(rect1, rect2) {
            return .Contains
        } else if CGRectContainsRect(rect2, rect1) {
            return .ContainedIn
        }
        
        return .PartiallyIntersects
    }
}

/** Concrete class encapsulating the necessary state for CollisionBehaviors */
class CollisionBehaviorBinding : BehaviorBinding {
    var previousState: CollisionState
    let config: CollisionBehavior
    
    init(hostLayer: Layer, config: CollisionBehavior) {
        self.config = config
        self.previousState = CollisionState.stateForLayer(hostLayer, andLayer: self.config.otherLayer)
        
        super.init(hostLayer: hostLayer)
    }

    override func update() {
        self.updateWithState(CollisionState.stateForLayer(self.hostLayer, andLayer: self.config.otherLayer))
    }
    
    func updateWithState(state: CollisionState) {
        let old = previousState
        switch (self.config.kind, old, state) {
            
        case (.Entering,.NonOverlapping,.PartiallyIntersects):
            fallthrough
        case (.Entering,.NonOverlapping,.ContainedIn):
            fallthrough
        case (.Entering,.NonOverlapping,.Contains):
            fire()
            
        case (.Leaving,.PartiallyIntersects,.NonOverlapping):
            fallthrough
        case (.Leaving,.ContainedIn,.NonOverlapping):
            fallthrough
        case (.Leaving,.Contains,.NonOverlapping):
            fire()
            
        default:
            ()
        }
        
        self.previousState = state
    }
    
    func fire() {
        self.config.handler()
    }
}

/** Concrete BehaviorBinding for ActionBehavior */
class ActionBehaviorBinding : BehaviorBinding {
    let config: ActionBehavior
    
    init(hostLayer: Layer, config: ActionBehavior) {
        self.config = config
        
        super.init(hostLayer: hostLayer)
    }
    
    override func update() {
        config.handler(hostLayer)
    }
}

//MARK: Behavior Driver

/** Manages all the behaviors in a given Environment */
class BehaviorDriver {
    var heartbeat: Heartbeat!
    
    var registeredBindings: Set<BehaviorBinding> {
        didSet {
            self.heartbeat.paused = self.registeredBindings.count == 0
        }
    }
    
    init() {
        self.registeredBindings = Set<BehaviorBinding>()
        
        self.heartbeat = Heartbeat { [unowned self] _ in
            self.tick()
        }
    }
    
    deinit {
        self.heartbeat.stop()
    }
    
    func tick() {
        for b in self.registeredBindings {
            b.update()
        }
    }
    
    func updateWithLayer(layer: Layer, behaviors: [BehaviorType]) {
        let knownBindings = lazy(self.registeredBindings).filter { $0.hostLayer == layer }
        
        let otherBindings = self.registeredBindings.subtract(knownBindings)
        
        let newBindings = behaviors.map { b -> BehaviorBinding in
            return self.createBindingForLayer(layer, behavior: b)!
        }
        
        self.registeredBindings = otherBindings.union(newBindings)
    }
    
    func registerBinding(binding: BehaviorBinding) {
        self.registeredBindings.insert(binding)
    }
    
    func unregisterBinding(binding: BehaviorBinding) {
        self.registeredBindings.remove(binding)
    }
    
    func createBindingForLayer(layer: Layer, behavior: BehaviorType) -> BehaviorBinding? {
        if let collisionBehavior = behavior as? CollisionBehavior {
            return CollisionBehaviorBinding(hostLayer: layer, config: collisionBehavior)
        } else if let actionBehavior = behavior as? ActionBehavior {
            return ActionBehaviorBinding(hostLayer: layer, config: actionBehavior)
        }
        return nil
    }
}
