//
//  NOSELAdvancedExampleView.m
//  NOCircleSelector
//
//  Created by Natalia Osiecka on 08.10.2014.
//  Copyright (c) 2014 iOskApps. All rights reserved.
//

#import "NOSELAdvancedExampleView.h"

@implementation NOSELAdvancedExampleView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setBackgroundColor:[UIColor blackColor]];
        
        _mediumCircleSelector = [[NOSELCircleSelector alloc] initWithFrame:frame];
        [self.mediumCircleSelector setBackgroundColor:[UIColor clearColor]];
        [self addSubview:self.mediumCircleSelector];
        
        [self.valueLabel setTextColor:[UIColor redColor]];
        
        [self.gradientLayer removeFromSuperlayer];
        self.gradientLayer = nil;
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.mediumCircleSelector setFrame:CGRectInset(self.bounds, 65.f, 65.f)];
}

@end
