//
//  NOSELMath.m
//  NOCircleSelector
//
//  Created by Natalia Osiecka on 06.2.2015.
//  Copyright (c) 2015 iOskApps. All rights reserved.
//

#import "NOSELMath.h"
#import <NOCategories/NOCMacros.h>

@implementation NOSELMath

+ (CGFloat)normalizeAngle:(CGFloat)angle {
    CGFloat normalizedAngle = intValue(angle) % 360;
    if (normalizedAngle < 0) {
        normalizedAngle = 360 + normalizedAngle;
    }
    
    return normalizedAngle;
}

+ (CGFloat)normalizedAngleInDegreesFromCircleSelectorRect:(CGRect)circleSelectorRect nearPoint:(CGPoint)point {
    CGPoint middleCirclePoint = CGPointMake(CGRectGetMidX(circleSelectorRect), CGRectGetMidY(circleSelectorRect));
    CGFloat deltaY = middleCirclePoint.y - point.y;
    CGFloat deltaX = middleCirclePoint.x - point.x;
    
    return [NOSELMath normalizeAngle:(atan2f(deltaY, deltaX) * 180 / M_PI - 90)];
}

+ (CGRect)dotRectWithAngle:(CGFloat)angle circleSelectorRect:(CGRect)circleSelectorRect dotRadius:(CGFloat)dotRadius {
    CGFloat radians = noc_radians(-angle);
    CGFloat radius = CGRectGetWidth(circleSelectorRect) / 2.f;
    CGPoint middleCirclePoint = CGPointMake(CGRectGetMidX(circleSelectorRect), CGRectGetMidY(circleSelectorRect));
    
    CGPoint center = CGPointMake(middleCirclePoint.x - radius * sin(radians), middleCirclePoint.y - radius * cos(radians));
    CGSize size = CGSizeMake(dotRadius * 2, dotRadius * 2);
    CGRect rect = CGRectIntegral(CGRectMake(center.x - size.width / 2, center.y - size.height / 2, size.width, size.height));
    
    return rect;
}

@end
