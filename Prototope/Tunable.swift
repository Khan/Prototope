//
//  Tunable.swift
//  Prototope
//
//  Created by Andy Matuschak on 1/13/15.
//  Copyright (c) 2015 Khan Academy. All rights reserved.
//

import Foundation

/* These functions allow you to take a value and make it tunable by a slider or a switch!

	Example usage:
		tunable(0.5, name: "button alpha") { alpha in someButton.alpha = alpha }
	Whenever the alpha changes, the closure will be run, and the button's alpha will be updated.

	If an instantaneous return value is good enough, you can do this instead:
		someButton.alpha = tunable(0.5, name: "button alpha")

	Once you've tuned values in the UI, you can apply them back to the project by following these steps:
	1. Tap "Share"

	2a. If you're attached to Xcode, open up the console (View > Debug Area > Activate Console) and look for a log like this:
		[
			{
			"label" : "Test",
			"key" : "Test",
			"sliderMinValue" : 0,
			"sliderMaxValue" : 1400,
			"sliderValue" : 179.6053
			}
		].

	2b. If you're not attached to Xcode, email yourself from the share sheet.

	3. Copy and paste the contents into TunableSpec.json in your project (included with OhaiPrototope). */

/** Returns the tunable value stored in TunableValues.json under `name`. If none is present, returns `defaultValue`. */
public func tunable(defaultValue: Double, name: String, min: Double? = nil, max: Double? = nil) -> Double {
	if let specItem = defaultSpec._KFSpecItemForKey(name) {
		return (specItem.objectValue as! NSNumber).doubleValue
	} else {
        let minValue = min ?? 0
        let maxValue = max ?? 2 * defaultValue
		defaultSpec.addDoubleSpecItemForKey(name, defaultValue: defaultValue, minValue: minValue, maxValue: maxValue)
		return defaultValue
	}
}

/** Whenever the named tunable value changes, runs `changeHandler` with the new value. Runs `changeHandler` once initially with the existing or default value. */
public func tunable(defaultValue: Double, name: String, min: Double? = nil, max: Double? = nil, changeHandler: Double -> Void) {
    tunable(defaultValue, name: name, min: min, max: max) // Make sure it exists
	defaultSpec.withDoubleForKey(name, owner: UIApplication.sharedApplication(), maintain: { owner, value in changeHandler(value) })
}

/** Returns the tunable value stored in TunableValues.json under `name`. If none is present, returns `defaultValue`. */
public func tunable(defaultValue: Bool, name: String) -> Bool {
	if let specItem = defaultSpec._KFSpecItemForKey(name) {
		return (specItem.objectValue as! NSNumber).boolValue
	} else {
		defaultSpec.addBoolSpecItemForKey(name, defaultValue: defaultValue)
		return defaultValue
	}
}

/** Whenever the named tunable value changes, runs `changeHandler` with the new value. Runs `changeHandler` once initially with the existing or default value. */
public func tunable(defaultValue: Bool, name: String, changeHandler: Bool -> Void) {
	tunable(defaultValue, name: name) // Make sure it exists
	defaultSpec.withBoolForKey(name, owner: UIApplication.sharedApplication(), maintain: { owner, value in changeHandler(value) })
}

/** Returns the tunable value stored in TunableValues.json under `name`. If none is present, returns `defaultValue`. */
public func tunable(defaultValue: Point, name: String) -> Point {
	return Point(
		x: tunable(defaultValue.x, name: "\(name).x"),
		y: tunable(defaultValue.y, name: "\(name).y")
	)
}

/** Whenever the named tunable value changes, runs `changeHandler` with the new value. Runs `changeHandler` once initially with the existing or default value. */
public func tunable(defaultValue: Point, name: String, changeHandler: Point -> Void) {
	tunable(defaultValue.x, name: "\(name).x", changeHandler: { x in changeHandler(Point(x: x, y: tunable(defaultValue.y, name: "\(name).y"))) })
	tunable(defaultValue.y, name: "\(name).y", changeHandler: { y in changeHandler(Point(x: tunable(defaultValue.x, name: "\(name).x"), y: y)) })
}

let defaultSpec = KFTunableSpec.specNamed("TunableValues") as! KFTunableSpec
