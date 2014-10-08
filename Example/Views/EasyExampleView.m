//
//  EasyExampleView.m
//  NOCircleSelector
//
//  Created by Natalia Osiecka on 08.10.2014.
//  Copyright (c) 2014 PifPaf. All rights reserved.
//

#import "EasyExampleView.h"

@implementation EasyExampleView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setBackgroundColor:[UIColor blackColor]];
        
        _mediumCircleSelector = [[NOCircleSelector alloc] initWithFrame:frame];
        [_mediumCircleSelector setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_mediumCircleSelector];
        
        [self.valueLabel setTextColor:[UIColor redColor]];
        
        [self.gradientLayer removeFromSuperlayer];
        self.gradientLayer = nil;
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_mediumCircleSelector setFrame:CGRectInset(self.bounds, 65.f, 65.f)];
}

@end
