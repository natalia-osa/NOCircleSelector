//
//  NOSELCircleDotConnection.h
//  NOCircleSelector
//
//  Created by Natalia Osiecka on 02.10.2014.
//  Copyright (c) 2014 iOskApps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NOSELCircleDot.h"

/**
 *  Defines the kind of connection between two dots.
 */
@interface NOSELCircleDotConnection : NSObject

/**
 *  Defines dot where we should start drawing.
 */
@property (nonatomic, weak) NOSELCircleDot *startDot;

/**
 *  Defines dot where we should end drawing.
 */
@property (nonatomic, weak) NOSELCircleDot *endDot;

/**
 *  Defines the color of line between 2 dots.
 */
@property (nonatomic) UIColor *connectionColor;

/**
 *  Defines the width of line between 2 dots.
 */
@property (nonatomic) CGFloat lineWidth;

/**
 *  Creates and configures dot connection of specified parameters.
 *
 *  @param dots            The array of all the NOSELCircleDots.
 *  @param index           The index between two dots, where the connection should be created.
 *  @param lineWidth       The width of line to draw.
 *  @param connectionColor The color of the line to draw.
 *
 *  @return Configured dot connection.
 */
+ (NOSELCircleDotConnection *)circleDotConnectionFromDots:(NSArray *)dots atIndex:(NSInteger)index lineWidth:(CGFloat)lineWidth connectionColor:(UIColor *)connectionColor;

/**
 *  Convenience method to compare two tags on connection.
 *
 *  @param tag1 First dot.tag.
 *  @param tag2 Second dot.tag.
 *
 *  @return If self is a connection between tag1 and tag2.
 */
- (BOOL)dotConnectionBeetweenTag1:(NSUInteger)tag1 tag2:(NSUInteger)tag2;

@end
