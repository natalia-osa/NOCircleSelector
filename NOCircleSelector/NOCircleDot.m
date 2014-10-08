//
//  NOCircleDot.m
//  NOCircleSelector
//
//  Created by Natalia Osiecka on 01.10.2014.
//  Copyright (c) 2014 Natalia Osiecka. All rights reserved.
//

#import "NOCircleDot.h"
#import <QuartzCore/QuartzCore.h>

@implementation NOCircleDot

#pragma mark - Memory management

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self commonInit];
    }
    
    return self;
}

- (void)commonInit {
    [self setOpaque:NO];
    [self setAutoresizesSubviews:YES];
    [self setContentMode:UIViewContentModeRedraw];
    
    _imageView = [[UIImageView alloc] init];
    [_imageView setContentMode:UIViewContentModeScaleAspectFill];
    [_imageView.layer setMasksToBounds:YES];
    [self addSubview:_imageView];
    
    _textLabel = [[UILabel alloc] init];
    [_textLabel setBackgroundColor:[UIColor clearColor]];
    [_textLabel setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:_textLabel];
    
    _lineWidth = 1.f;
    _angle = 0.f;
    _minAngle = 0.f;
    _maxAngle = 360.f;
    _lineColor = [UIColor blueColor];
    _fillColor = [UIColor clearColor];
}

#pragma mark - Setters / Getters

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    [super setBackgroundColor:backgroundColor];
    [self setNeedsDisplay];
}

- (void)setLineColor:(UIColor *)lineColor {
    _lineColor = lineColor;
    [self setNeedsDisplay];
}

- (void)setFillColor:(UIColor *)fillColor {
    _fillColor = fillColor;
    [self setNeedsDisplay];
}

- (void)setLineWidth:(CGFloat)lineWidth {
    _lineWidth = lineWidth;
    [self setNeedsDisplay];
}

#pragma mark - Drawing code

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect frame = self.bounds;
    [_textLabel setFrame:frame];
    
    CGRect imageViewFrame = CGRectIntegral(CGRectInset(frame, _lineWidth, _lineWidth));
    [_imageView setFrame:imageViewFrame];
    
    CGFloat imageViewCornerRadius = (CGRectGetWidth(imageViewFrame) / 2.f);
    [_imageView.layer setCornerRadius:imageViewCornerRadius];
}

- (void)drawRect:(CGRect)rect {
    [self drawCircle];
}

- (void)drawCircle {
    // setup context
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClearRect(context, self.bounds);
    
    // draw background color
    CGContextSetFillColorWithColor(context, self.backgroundColor.CGColor);
    CGContextFillRect(context, self.bounds);
    
    // get variables
    CGRect circleRect = CGRectInset(self.bounds, _lineWidth, _lineWidth);
    
    // draw circle fillColor
    if (_fillColor != [UIColor clearColor]) {
        CGContextSaveGState(context);
        CGContextAddEllipseInRect(context, circleRect);
        CGContextClip(context);
        CGContextSetFillColorWithColor(context, _fillColor.CGColor);
        CGContextFillRect(context, circleRect);
        CGContextRestoreGState(context);
    }
    
    // draw the circle around
    CGContextSetLineWidth(context, _lineWidth);
    CGContextBeginPath(context);
    CGContextSetStrokeColorWithColor(context, _lineColor.CGColor);
    CGContextAddArc(context, CGRectGetMidX(circleRect), CGRectGetMidY(circleRect), MIN(CGRectGetWidth(circleRect), CGRectGetHeight(circleRect)) / 2.f, radians(0), radians(360), NO);
    CGContextStrokePath(context);
}

#pragma mark - Class methods

+ (NSInteger)valueForAngle:(CGFloat)angle maxAngle:(CGFloat)maxAngle maxValue:(CGFloat)maxValue {
    return floorf(maxValue * angle / maxAngle);
}

+ (NOCircleDot *)dotWithTag:(NSUInteger)tag fromDots:(NSArray *)dots {
    for (NOCircleDot *dot in dots) {
        if (dot.tag == tag) {
            return dot;
        }
    }
    
    return nil;
}

@end
