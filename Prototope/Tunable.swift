//
//  Tunable.swift
//  Prototope
//
//  Created by Andy Matuschak on 1/13/15.
//  Copyright (c) 2015 Khan Academy. All rights reserved.
//

import Foundation

/** Returns the tunable value stored in TunableValues.json under `name`. If none is present, returns `defaultValue`. */
public func tunable(defaultValue: Double, #name: String) -> Double {
	if let specItem = defaultSpec._KFSpecItemForKey(name) {
		return (specItem.objectValue as NSNumber).doubleValue
	} else {
		defaultSpec.addDoubleSpecItemForKey(name, defaultValue: defaultValue)
		return defaultValue
	}
}

/** Whenever the named tunable value changes, runs `maintain` with the new value. Runs `maintain` once initially with the existing or default value. */
public func tunable(defaultValue: Double, #name: String, #maintain: Double -> Void) {
	tunable(defaultValue, name: name) // Make sure it exists
	defaultSpec.withDoubleForKey(name, owner: UIApplication.sharedApplication(), maintain: { owner, value in maintain(value) })
}

/** Returns the tunable value stored in TunableValues.json under `name`. If none is present, returns `defaultValue`. */
public func tunable(defaultValue: Bool, #name: String) -> Bool {
	if let specItem = defaultSpec._KFSpecItemForKey(name) {
		return (specItem.objectValue as NSNumber).boolValue
	} else {
		defaultSpec.addBoolSpecItemForKey(name, defaultValue: defaultValue)
		return defaultValue
	}
}

/** Whenever the named tunable value changes, runs `maintain` with the new value. Runs `maintain` once initially with the existing or default value. */
public func tunable(defaultValue: Bool, #name: String, #maintain: Bool -> Void) {
	tunable(defaultValue, name: name) // Make sure it exists
	defaultSpec.withBoolForKey(name, owner: UIApplication.sharedApplication(), maintain: { owner, value in maintain(value) })
}

/** Returns the tunable value stored in TunableValues.json under `name`. If none is present, returns `defaultValue`. */
public func tunable(defaultValue: Point, #name: String) -> Point {
	return Point(
		x: tunable(defaultValue.x, name: "\(name).x"),
		y: tunable(defaultValue.y, name: "\(name).y")
	)
}

/** Whenever the named tunable value changes, runs `maintain` with the new value. Runs `maintain` once initially with the existing or default value. */
public func tunable(defaultValue: Point, #name: String, #maintain: Point -> Void) {
	tunable(defaultValue.x, name: "\(name).x", maintain: { x in maintain(Point(x: x, y: tunable(defaultValue.y, name: "\(name).y"))) })
	tunable(defaultValue.y, name: "\(name).y", maintain: { y in maintain(Point(x: tunable(defaultValue.x, name: "\(name).x"), y: y)) })
}

let defaultSpec = KFTunableSpec.specNamed("TunableValues") as KFTunableSpec