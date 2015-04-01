//
//  UIBezierPath+Segment.swift
//  Prototope
//
//  Created by Jason Brennan on 2015-03-31.
//  Copyright (c) 2015 Khan Academy. All rights reserved.
//

import UIKit

extension UIBezierPath {
	var segments: [Segment] {
		var segments = [Segment]()
		
		self.enumeratePathElementsWithCallback { 
			(type: CGPathElementType, point: CGPoint, firstControlPoint: CGPoint, secondControlPoint: CGPoint) -> Void in
			
			switch type.value {
			case kCGPathElementAddCurveToPoint.value:
				println("add curve to point")
			case kCGPathElementAddLineToPoint.value:
				println("add line to point")
			case kCGPathElementAddQuadCurveToPoint.value:
				println("add quad curve to point")
			case kCGPathElementCloseSubpath.value:
				println("close subpath")
			case kCGPathElementMoveToPoint.value:
				println("move to point")
				
			default:
				println("unknown path element")
			}

			
			if let point = Point(potentiallyNoneCGPoint: point) {
				let cp1 = Point(potentiallyNoneCGPoint: firstControlPoint)
				let cp2 = Point(potentiallyNoneCGPoint: secondControlPoint)
				
				segments.append(Segment(point: point, handleIn: cp1, handleOut: cp2))
				
			}
			
			
			
		}
		

		return segments
	}
}


extension Point {
	init?(potentiallyNoneCGPoint point: CGPoint) {
		if point == PrototopeCGPointNone {
			return nil
		}
		
		self.init(point)
	}
}
