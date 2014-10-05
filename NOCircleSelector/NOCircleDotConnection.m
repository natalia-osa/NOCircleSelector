//
//  NOCircleDotConnection.m
//  NOCircleSelector
//
//  Created by Natalia Osiecka on 02.10.2014.
//  Copyright (c) 2014 Natalia Osiecka. All rights reserved.
//

#import "NOCircleDotConnection.h"

@implementation NOCircleDotConnection

- (BOOL)dotConnectionBeetweenTag1:(NSUInteger)tag1 tag2:(NSUInteger)tag2 {
    BOOL isClockWiseConnection = (self.startDot.tag == tag1 && self.endDot.tag == tag2);
    BOOL isOppositeClockConnection = (self.startDot.tag == tag2 && self.endDot.tag == tag1);
    
    return (isClockWiseConnection || isOppositeClockConnection);
}

@end
