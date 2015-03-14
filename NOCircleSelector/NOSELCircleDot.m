//
//  NOSELCircleDot.m
//  NOCircleSelector
//
//  Created by Natalia Osiecka on 01.10.2014.
//  Copyright (c) 2014 iOskApps. All rights reserved.
//

#import "NOSELCircleDot.h"
#import "NOSELMath.h"
#import <QuartzCore/QuartzCore.h>
#import <NOCategories/NOCMacros.h>

@implementation NOSELCircleDot

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
    [self.textLabel setFrame:frame];
    
    CGRect imageViewFrame = CGRectIntegral(CGRectInset(frame, self.lineWidth, self.lineWidth));
    [self.imageView setFrame:imageViewFrame];
    
    CGFloat imageViewCornerRadius = (CGRectGetWidth(imageViewFrame) / 2.f);
    [self.imageView.layer setCornerRadius:imageViewCornerRadius];
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
    
    CGRect circleRect = CGRectInset(self.bounds, self.lineWidth, self.lineWidth);
    [self drawCircleInRect:circleRect usingFillColor:self.fillColor inContext:context];
    [self drawCircleAroundRect:circleRect usingLineWidth:self.lineWidth lineColor:self.lineColor inContext:context];
}

- (void)drawCircleInRect:(CGRect)circleRect usingFillColor:(UIColor *)fillColor inContext:(CGContextRef)context {
    if (fillColor != [UIColor clearColor]) {
        CGContextSaveGState(context);
        CGContextAddEllipseInRect(context, circleRect);
        CGContextClip(context);
        CGContextSetFillColorWithColor(context, fillColor.CGColor);
        CGContextFillRect(context, circleRect);
        CGContextRestoreGState(context);
    }
}

- (void)drawCircleAroundRect:(CGRect)circleRect usingLineWidth:(CGFloat)lineWidth lineColor:(UIColor *)lineColor inContext:(CGContextRef)context {
    CGContextSetLineWidth(context, lineWidth);
    CGContextBeginPath(context);
    CGContextSetStrokeColorWithColor(context, lineColor.CGColor);
    CGContextAddArc(context, CGRectGetMidX(circleRect), CGRectGetMidY(circleRect), MIN(CGRectGetWidth(circleRect), CGRectGetHeight(circleRect)) / 2.f, noc_radians(0), noc_radians(360), NO);
    CGContextStrokePath(context);
}

#pragma mark - Class methods

+ (CGFloat)valueForAngle:(CGFloat)angle maxAngle:(CGFloat)maxAngle maxValue:(CGFloat)maxValue minAngle:(CGFloat)minAngle minValue:(CGFloat)minValue {
    return minValue + (angle - minAngle) * (maxValue - minValue) / (maxAngle - minAngle);
}

+ (CGFloat)angleForValue:(CGFloat)value maxAngle:(CGFloat)maxAngle maxValue:(CGFloat)maxValue minAngle:(CGFloat)minAngle minValue:(CGFloat)minValue {
    return (value - minValue) * (maxAngle - minAngle) / (maxValue - minValue) + minAngle;
}

+ (NOSELCircleDot *)dotWithTag:(NSUInteger)tag fromDots:(NSArray *)dots {
    for (NOSELCircleDot *dot in dots) {
        if (dot.tag == tag) {
            return dot;
        }
    }
    
    return nil;
}

@end
