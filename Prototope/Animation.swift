//
//  Animation.swift
//  Prototope
//
//  Created by Andy Matuschak on 10/8/14.
//  Copyright (c) 2014 Khan Academy. All rights reserved.
//

import UIKit

// TODO: Revisit. Don't really like these yet.

public func animateWithDuration(duration: NSTimeInterval, #animations: () -> Void) {
	UIView.animateWithDuration(duration, delay: 0.0, options: .AllowUserInteraction, animations: animations, completion: nil)
}

public func animateWithDuration(duration: NSTimeInterval, #animations: () -> Void, #completionHandler: () -> Void) {
	UIView.animateWithDuration(duration, delay: 0.0, options: .AllowUserInteraction, animations: animations, completion: { _ in completionHandler() })
}
