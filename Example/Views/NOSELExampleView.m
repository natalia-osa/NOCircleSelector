//
//  NOSELExampleView.m
//  NOCircleSelector
//
//  Created by Natalia Osiecka on 30.9.2014.
//  Copyright (c) 2014 iOskApps. All rights reserved.
//

#import "NOSELExampleView.h"

@implementation NOSELExampleView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setContentMode:UIViewContentModeRedraw];
        
        self.gradientLayer = [CAGradientLayer layer];
        self.gradientLayer.frame = self.bounds;
        self.gradientLayer.colors = [NSArray arrayWithObjects:(id)[[UIColor orangeColor] CGColor], (id)[[UIColor yellowColor] CGColor], nil];
        [self.layer insertSublayer:self.gradientLayer atIndex:0];
        
        _circleSelector = [[NOSELCircleSelector alloc] initWithFrame:frame];
        [self.circleSelector setBackgroundColor:[UIColor clearColor]];
        [self addSubview:self.circleSelector];
        
        _smallCircleSelector = [[NOSELCircleSelector alloc] initWithFrame:frame];
        [self.smallCircleSelector setBackgroundColor:[UIColor clearColor]];
        [self addSubview:self.smallCircleSelector];
        
        _valueLabel = [[UILabel alloc] init];
        [self.valueLabel setBackgroundColor:[UIColor clearColor]];
        [self.valueLabel setTextAlignment:NSTextAlignmentCenter];
        [self.valueLabel setFont:[UIFont systemFontOfSize:40.f]];
        [self addSubview:self.valueLabel];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.circleSelector setFrame:self.bounds];
    [self.smallCircleSelector setFrame:CGRectInset(self.bounds, 100.f, 100.f)];
    [self.valueLabel setFrame:self.bounds];
}

- (void)layoutSublayersOfLayer:(CALayer *)layer {
    [super layoutSublayersOfLayer:layer];
    
    [self.layer.sublayers.firstObject setFrame:self.bounds];
}

@end
