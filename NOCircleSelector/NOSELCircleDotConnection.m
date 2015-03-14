//
//  NOSELCircleDotConnection.m
//  NOCircleSelector
//
//  Created by Natalia Osiecka on 02.10.2014.
//  Copyright (c) 2014 iOskApps. All rights reserved.
//

#import "NOSELCircleDotConnection.h"

@implementation NOSELCircleDotConnection

+ (NOSELCircleDotConnection *)circleDotConnectionFromDots:(NSArray *)dots atIndex:(NSInteger)index lineWidth:(CGFloat)lineWidth connectionColor:(UIColor *)connectionColor {
    NOSELCircleDotConnection *connection = [[NOSELCircleDotConnection alloc] init];
    [connection setLineWidth:lineWidth];
    [connection setConnectionColor:connectionColor];
    [connection setStartDot:dots[index]];
    if (dots.count > (index + 1)) {
        [connection setEndDot:dots[(index + 1)]];
    } else {
        [connection setEndDot:dots[0]];
    }
    
    return connection;
}

- (BOOL)dotConnectionBeetweenTag1:(NSUInteger)tag1 tag2:(NSUInteger)tag2 {
    BOOL isClockWiseConnection = (self.startDot.tag == tag1 && self.endDot.tag == tag2);
    BOOL isOppositeClockConnection = (self.startDot.tag == tag2 && self.endDot.tag == tag1);
    
    return (isClockWiseConnection || isOppositeClockConnection);
}

@end
