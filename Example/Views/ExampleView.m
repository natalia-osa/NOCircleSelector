//
//  ExampleView.m
//  NOCircleSelector
//
//  Created by Natalia Osiecka on 30.9.2014.
//  Copyright (c) 2014 Natalia Osiecka. All rights reserved.
//

#import "ExampleView.h"

@interface ExampleView ()

@property (nonatomic, strong) CAGradientLayer *gradientLayer;

@end

@implementation ExampleView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setContentMode:UIViewContentModeRedraw];
        
        _gradientLayer = [CAGradientLayer layer];
        _gradientLayer.frame = self.bounds;
        _gradientLayer.colors = [NSArray arrayWithObjects:(id)[[UIColor orangeColor] CGColor], (id)[[UIColor yellowColor] CGColor], nil];
        [self.layer insertSublayer:_gradientLayer atIndex:0];
        
        _circleSelector = [[NOCircleSelector alloc] initWithFrame:frame];
        [_circleSelector setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_circleSelector];
        
        _smallCircleSelector = [[NOCircleSelector alloc] initWithFrame:frame];
        [_smallCircleSelector setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_smallCircleSelector];
        
        _valueLabel = [[UILabel alloc] init];
        [_valueLabel setBackgroundColor:[UIColor clearColor]];
        [_valueLabel setTextAlignment:NSTextAlignmentCenter];
        [_valueLabel setFont:[UIFont systemFontOfSize:40.f]];
        [self addSubview:_valueLabel];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_circleSelector setFrame:self.bounds];
    [_smallCircleSelector setFrame:CGRectInset(self.bounds, 100.f, 100.f)];
    [_valueLabel setFrame:self.bounds];
}

- (void)layoutSublayersOfLayer:(CALayer *)layer {
    [super layoutSublayersOfLayer:layer];
    
    [self.layer.sublayers[0] setFrame:self.bounds];
}

@end
