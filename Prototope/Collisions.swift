//
//  Collisions.swift
//  Prototope
//
//  Created by Saniul Ahmed on 07/02/2015.
//  Copyright (c) 2015 Khan Academy. All rights reserved.
//

import Foundation

var globalConstraintStore = ConstraintStore()

class ConstraintStore {

    let heartbeat: Heartbeat!

    var registeredConstraints: [Constraint] {
        didSet {
            self.heartbeat.paused = self.registeredConstraints.count == 0
        }
    }

    init() {
        self.registeredConstraints = [Constraint]()
        self.heartbeat = Heartbeat { _ in
            self.tick()
        }
    }

    func tick() {
        for c in self.registeredConstraints {
            c.update()
        }
    }

    func registerConstraint(constraint: Constraint) {
        self.registeredConstraints.append(constraint)
    }

    func unregisterConstraint(constraint: Constraint) {
        if let idx = find(self.registeredConstraints, constraint) {
            self.registeredConstraints.removeAtIndex(idx)
        }
    }
}

public func when(l: Layer) -> ConstraintLHS {
    return ConstraintLHS(layer1: l)
}

public struct ConstraintLHS {
    public typealias Handler = () -> Void
    
    let layer1: Layer
    
    public func collidesWith(layer2: Layer, handler: Handler) -> Constraint {
        return Constraint(layer1: layer1, layer2: layer2, kind: .Collides, handler: handler)
    }
    
    public func enters(layer2: Layer, handler: Handler) -> Constraint {
        return Constraint(layer1: layer1, layer2: layer2, kind: .Enters, handler: handler)
    }
    
    public func leaves(layer2: Layer, handler: Handler) -> Constraint {
        return Constraint(layer1: layer1, layer2: layer2, kind: .Leaves, handler: handler)
    }
    
    public func isContainedIn(layer2: Layer, handler: Handler) -> Constraint {
        return Constraint(layer1: layer1, layer2: layer2, kind: .IsContainedIn, handler: handler)
    }

    public func contains(layer2: Layer, handler: Handler) -> Constraint {
        return Constraint(layer1: layer1, layer2: layer2, kind: .Contains, handler: handler)
    }
}


enum ConstraintKind {
    case Collides
    
    case IsContainedIn
    case Contains
    
    case Enters
    case Leaves
}

enum ConstraintState {
    case NonOverlapping
    case PartiallyIntersects
    case ContainedIn
    case Contains
}

func stateForLayer(layer1: Layer, andLayer layer2: Layer) -> ConstraintState {
    let rect1 = CGRect(layer1.frame)
    let rect2 = CGRect(layer2.frame)
    
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

public func ==(c1: Constraint, c2: Constraint) -> Bool {
    return c1.id == c2.id
}


var constraintCounter = 0
public class Constraint : Equatable {

    let id: Int
    let layer1: Layer
    let layer2: Layer
    let kind: ConstraintKind
    var previousState: ConstraintState
    
    let handler: () -> Void
    
    init(layer1: Layer, layer2: Layer, kind: ConstraintKind, handler: () -> Void) {
        self.id = constraintCounter++
        self.layer1 = layer1
        self.layer2 = layer2
        self.kind = kind
        self.previousState = stateForLayer(layer1, andLayer: layer2)
        self.handler = handler

        globalConstraintStore.registerConstraint(self)
    }

    func update() {
        self.updateWithState(stateForLayer(layer1, andLayer: layer2))
    }
    
    func updateWithState(state: ConstraintState) {
        let old = previousState
        switch (kind, old, state) {
        case (.Collides,_,.PartiallyIntersects):
            fallthrough
        case (.Collides,_,.ContainedIn):
            fallthrough
        case (.Collides,_,.Contains):
            fire()
            
        case (.IsContainedIn,_,.ContainedIn):
            fire()
            
        case (.Contains,_,.Contains):
            fire()
            
        case (.Enters,.NonOverlapping,.PartiallyIntersects):
            fallthrough
        case (.Enters,.NonOverlapping,.ContainedIn):
            fallthrough
        case (.Enters,.NonOverlapping,.Contains):
            fire()
            
        case (.Leaves,.PartiallyIntersects,.NonOverlapping):
            fallthrough
        case (.Leaves,.ContainedIn,.NonOverlapping):
            fallthrough
        case (.Leaves,.Contains,.NonOverlapping):
            fire()
            
        default:
            ()
        }
        
        self.previousState = state
    }
    
    func fire() {
        handler ()
    }

}