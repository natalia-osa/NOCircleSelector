//
//  NOSELMath.h
//  NOCircleSelector
//
//  Created by Natalia Osiecka on 06.2.2015.
//  Copyright (c) 2015 iOskApps. All rights reserved.
//

#import <UIKit/UIKit.h>

#define intValue(x) (int)noc_floorCGFloat(x)

@interface NOSELMath : NSObject

+ (CGFloat)normalizeAngle:(CGFloat)angle;

+ (CGFloat)normalizedAngleInDegreesFromCircleSelectorRect:(CGRect)circleSelectorRect nearPoint:(CGPoint)point;

+ (CGRect)dotRectWithAngle:(CGFloat)angle circleSelectorRect:(CGRect)circleSelectorRect dotRadius:(CGFloat)dotRadius;

@end
