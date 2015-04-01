//
//  UIBezierPath+Apply.m
//  Prototope
//
//  Created by Jason Brennan on 2015-03-31.
//  Copyright (c) 2015 Khan Academy. All rights reserved.
//

#import "UIBezierPath+Apply.h"

const CGPoint PrototopeCGPointNone = (CGPoint){CGFLOAT_MAX, CGFLOAT_MAX};

static void applier(void *info, const CGPathElement *element) {
	PrototopeEnumeratePathElementsCallback block = (__bridge PrototopeEnumeratePathElementsCallback)info;
	CGPathElementType type = element->type;
	CGPoint *points = element->points;
	
	CGPoint point = PrototopeCGPointNone;
	CGPoint firstControlPoint = PrototopeCGPointNone;
	CGPoint secondControlPoint = PrototopeCGPointNone;

	
	switch (type) {
		case kCGPathElementMoveToPoint:
			/* fallthrough */
			
		case kCGPathElementAddLineToPoint:
			point = points[0];
			break;
			
		case kCGPathElementAddCurveToPoint:
			firstControlPoint = points[0];
			secondControlPoint = points[1];
			point = points[2];
			break;
			
		case kCGPathElementAddQuadCurveToPoint:
			firstControlPoint = points[0];
			secondControlPoint = points[1];
			break;
			
		case kCGPathElementCloseSubpath:
			break;
	}
	
	block(type, point, firstControlPoint, secondControlPoint);
}

@implementation UIBezierPath (Apply)

- (void)enumeratePathElementsWithCallback:(PrototopeEnumeratePathElementsCallback)callback {
	CGPathApply(self.CGPath, (void *)callback, applier);
}

@end
