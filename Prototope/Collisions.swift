//
//  Collisions.swift
//  Prototope
//
//  Created by Saniul Ahmed on 07/02/2015.
//  Copyright (c) 2015 Khan Academy. All rights reserved.
//

import Foundation

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

struct Constraint {
    let kind: ConstraintKind
    
    var previousState: ConstraintState
    
    let handler: () -> Void
    
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
    }
    
    func fire() {
        handler ()
    }
}