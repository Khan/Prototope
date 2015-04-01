//
//  UIBezierPath+Apply.h
//  Prototope
//
//  Created by Jason Brennan on 2015-03-31.
//  Copyright (c) 2015 Khan Academy. All rights reserved.
//

#import <UIKit/UIKit.h>

extern const CGPoint PrototopeCGPointNone;
typedef void(^PrototopeEnumeratePathElementsCallback)(CGPathElementType type, CGPoint point, CGPoint firstControlPoint, CGPoint secondControlPoint);

@interface UIBezierPath (Apply)
- (void)enumeratePathElementsWithCallback:(PrototopeEnumeratePathElementsCallback)callback;
@end
