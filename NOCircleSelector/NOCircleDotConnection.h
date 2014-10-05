//
//  NOCircleDotConnection.h
//  NOCircleSelector
//
//  Created by Natalia Osiecka on 02.10.2014.
//  Copyright (c) 2014 Natalia Osiecka. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NOCircleDot.h"

/**
 *  Defines the kind of connection between two dots.
 */
@interface NOCircleDotConnection : NSObject

/**
 *  Defines dot where we should start drawing.
 */
@property (nonatomic, weak) NOCircleDot *startDot;

/**
 *  Defines dot where we should end drawing.
 */
@property (nonatomic, weak) NOCircleDot *endDot;

/**
 *  Defines the color of line between 2 dots.
 */
@property (nonatomic) UIColor *connectionColor;

/**
 *  Defines the width of line between 2 dots.
 */
@property (nonatomic) CGFloat lineWidth;

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
