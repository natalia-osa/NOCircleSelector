//
//  NOCircleDot.h
//  NOCircleSelector
//
//  Created by Natalia Osiecka on 01.10.2014.
//  Copyright (c) 2014 Natalia Osiecka. All rights reserved.
//

#import <UIKit/UIKit.h>

#define radians(x) (x * M_PI / 180)
#define degrees(x) (x * 180 / M_PI)

@interface NOCircleDot : UIView

/**
 *  Determines the width of selector line. Default 1.
 */
@property (nonatomic) CGFloat lineWidth;

/**
 *  Determines the color of selector line. Default blueColor.
 */
@property (nonatomic) UIColor *lineColor;

/**
 *  Determines the color of selector insides. Default clearColor.
 */
@property (nonatomic) UIColor *fillColor;

/**
 *  Label shown in middle of circle. By default no text.
 */
@property (nonatomic, readonly) UILabel *textLabel;

/**
 *  Defines in angle in degrees. Default 0.
 */
@property (nonatomic) CGFloat angle;

/**
 *  Defines angle below which we can't move the dot. 0 means no limit. Default 0.
 */
@property (nonatomic) CGFloat minAngle;

/**
 *  Defines angle above which we can't move the dot. 360 means no limit. Default 360.
 */
@property (nonatomic) CGFloat maxAngle;

@end
