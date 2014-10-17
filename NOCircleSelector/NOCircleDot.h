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
 *  Image shown in middle of circle. By default no image.
 */
@property (nonatomic, readonly) UIImageView *imageView;

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

/**
 *  Convenience method to calculate value for given angle.
 *
 *  @param angle    Angle to translate into another coordinate system.
 *  @param maxAngle Max angle for given dot (degrees).
 *  @param maxValue Max value for given dot.
 *  @param minAngle Min angle for given dot (degrees).
 *  @param minValue Min value for given dot.
 *
 *  @return Value for given angle.
 */
+ (CGFloat)valueForAngle:(CGFloat)angle maxAngle:(CGFloat)maxAngle maxValue:(CGFloat)maxValue minAngle:(CGFloat)minAngle minValue:(CGFloat)minValue;

/**
 *  Convenience method to calculate angle for given value.
 *
 *  @param value    Value to translate into another coordinate system.
 *  @param maxAngle Max angle for given dot (degrees).
 *  @param maxValue Max value for given dot.
 *  @param maxAngle Max angle for given dot (degrees).
 *  @param maxValue Max value for given dot.
 *
 *  @return Angle for given value.
 */
+ (CGFloat)angleForValue:(CGFloat)value maxAngle:(CGFloat)maxAngle maxValue:(CGFloat)maxValue minAngle:(CGFloat)minAngle minValue:(CGFloat)minValue;

/**
 *  Convenience method to get dot with tag.
 *
 *  @param tag  Tag of needed dot.
 *  @param dots Array with NOCircleDots.
 *
 *  @return Dot with given tag. Nil if dots doesn't contain it.
 */
+ (NOCircleDot *)dotWithTag:(NSUInteger)tag fromDots:(NSArray *)dots;

/**
 *  Public common initializer. Override and don't forget to call super.
 */
- (void)commonInit;

@end
