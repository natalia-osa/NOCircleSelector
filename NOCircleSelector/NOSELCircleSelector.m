//
//  NOSELCircleSelector.m
//  NOCircleSelector
//
//  Created by Natalia Osiecka on 30.9.2014.
//  Copyright (c) 2014 iOskApps. All rights reserved.
//

#import "NOSELCircleSelector.h"
#import "NOSELMath.h"
#import <NOCategories/NOCCGFloatMath.h>

@interface NOSELCircleSelector ()

@property (nonatomic) CGRect circleSelectorRect;
@property (nonatomic) NOSELCircleDot *tappedCircleDot;

@end

@implementation NOSELCircleSelector

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
    
    _allowsCycling = YES;
    _tappedCircleDot = nil;
    _numberOfDots = 0;
    _lineWidth = 1.f;
    _dotRadius = 10.f;
    _shadowWidth = 0;
    _lineColor = [UIColor redColor];
    _fillColor = [UIColor clearColor];
    _shadowColor = [UIColor blackColor];
}

#pragma mark - Setters / Getters

- (void)setNumberOfDots:(NSInteger)numberOfDots {
    _numberOfDots = numberOfDots;
    
    // create new dots
    NSMutableArray *mDots = [NSMutableArray new];
    for (NSInteger i = 0; i < numberOfDots; i++) {
        NOSELCircleDot *dot = nil;
        if ([self.delegate respondsToSelector:@selector(circleSelectorRequestsNOCircleDotClass:)]) {
            dot = [[[self.delegate circleSelectorRequestsNOCircleDotClass:self] alloc] init];
        }
        if (!dot) {
            dot = [[NOSELCircleDot alloc] init];
        }
        [dot setBackgroundColor:[self backgroundColor]];
        [mDots addObject:dot];
    }
    
    // create new dotConnections with default values
    NSMutableArray *mDotConnections = [NSMutableArray new];
    for (NSInteger i = 0; i < numberOfDots; i++) {
        [mDotConnections addObject:[NOSELCircleDotConnection circleDotConnectionFromDots:mDots atIndex:i lineWidth:self.lineWidth connectionColor:self.lineColor]];
    }
    
    // and call the setter of dots
    [self setDots:[mDots copy]];
    // update the connections
    [self setDotConnections:[mDotConnections copy]];
}

- (void)setDotConnections:(NSArray *)dotConnections {
    _dotConnections = dotConnections;
    
    // inform the delegate
    if ([self.delegate respondsToSelector:@selector(circleSelector:changedDotConnections:)]) {
        [self.delegate circleSelector:self changedDotConnections:self.dotConnections];
    }
    
    // update the view
    [self setNeedsDisplay];
}

- (void)setDots:(NSArray *)dots {
    // firstly delete old dots
    for (NOSELCircleDot *dot in self.dots) {
        [dot removeFromSuperview];
    }
    // update the dots
    _dots = dots;
    // now create new ones
    for (NOSELCircleDot *dot in self.dots) {
        [self addSubview:dot];
    }
    
    // inform the delegate
    if ([self.delegate respondsToSelector:@selector(circleSelector:changedDots:)]) {
        [self.delegate circleSelector:self changedDots:dots];
        // then call update on each dot
        if ([self.delegate respondsToSelector:@selector(circleSelector:updatedDot:)]) {
            for (NOSELCircleDot *dot in dots) {
                [self.delegate circleSelector:self updatedDot:dot];
            }
        }
    }
    
    // update the view
    [self setNeedsDisplay];
}

- (void)setDotRadius:(CGFloat)dotRadius {
    _dotRadius = dotRadius;
    [self setNeedsDisplay];
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    [super setBackgroundColor:backgroundColor];
    [self setNeedsDisplay];
}

- (void)setLineColor:(UIColor *)lineColor {
    _lineColor = lineColor;
    [self setNeedsDisplay];
}

- (void)setLineWidth:(CGFloat)lineWidth {
    _lineWidth = lineWidth;
    [self setNeedsDisplay];
}

- (void)setFillColor:(UIColor *)fillColor {
    _fillColor = fillColor;
    [self setNeedsDisplay];
}

- (void)setShadowColor:(UIColor *)shadowColor {
    _shadowColor = shadowColor;
    [self setNeedsDisplay];
}

#pragma mark - Drawing code

- (void)layoutSubviews {
    [super layoutSubviews];
    
    for (NOSELCircleDot *dot in self.dots) {
        [self updateDotPosition:dot];
    }
}

- (void)drawRect:(CGRect)rect {
    // get variables
    CGRect frame = self.bounds;
    CGFloat sideLength = MIN(CGRectGetWidth(frame), CGRectGetHeight(frame)) / 2.f - self.dotRadius;
    self.circleSelectorRect = CGRectMake(CGRectGetMidX(frame) - sideLength, CGRectGetMidY(frame) - sideLength, sideLength * 2, sideLength * 2);
    
    [self setNeedsLayout];
    [self drawCircle];
}

- (void)drawCircle {
    // setup context
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClearRect(context, self.bounds);
    
    // draw the circle using personalized connections
    for (NOSELCircleDotConnection *dotConnection in self.dotConnections) {
        [self drawCircleConnection:dotConnection inContext:context circleSelectorRect:self.circleSelectorRect];
    }
    
    CGContextSetLineWidth(context, self.lineWidth);
    [self fillCircleWithColor:self.fillColor inContext:context circleSelectorRect:self.circleSelectorRect];
    for (NOSELCircleDot *dot in self.dots) {
        if (!dot.shouldDrawConnectionBehind)  {
            [self clearCircleDot:dot inContext:context];
        }
    }
    
    // draw background color
    CGContextSetFillColorWithColor(context, self.backgroundColor.CGColor);
    CGContextFillRect(context, self.bounds);
}

- (void)clearCircleDot:(NOSELCircleDot *)dot inContext:(CGContextRef)context {
    CGContextSaveGState(context);
    CGRect clippingEllipseRect = [NOSELMath dotRectWithAngle:dot.angle circleSelectorRect:self.circleSelectorRect dotRadius:self.dotRadius];
    CGContextAddEllipseInRect(context, clippingEllipseRect);
    CGContextClip(context);
    CGContextClearRect(context, clippingEllipseRect);
    CGContextRestoreGState(context);
}

- (void)fillCircleWithColor:(UIColor *)fillColor inContext:(CGContextRef)context circleSelectorRect:(CGRect)circleSelectorRect {
    if (fillColor != [UIColor clearColor]) {
        CGContextSaveGState(context);
        CGContextAddEllipseInRect(context, CGRectInset(circleSelectorRect, self.lineWidth / 2.f, self.lineWidth / 2.f));
        CGContextClip(context);
        CGContextSetFillColorWithColor(context, fillColor.CGColor);
        CGContextFillRect(context, circleSelectorRect);
        CGContextRestoreGState(context);
    }
}

- (void)drawCircleConnection:(NOSELCircleDotConnection *)dotConnection inContext:(CGContextRef)context circleSelectorRect:(CGRect)circleSelectorRect {
    CGContextSetLineWidth(context, dotConnection.lineWidth);
    CGContextBeginPath(context);
    CGContextSetStrokeColorWithColor(context, dotConnection.connectionColor.CGColor);
    CGFloat smallerAngle = [NOSELMath normalizeAngle:dotConnection.startDot.angle - 90];
    CGFloat biggerAngle = [NOSELMath normalizeAngle:dotConnection.endDot.angle - 90];
    CGContextAddArc(context, CGRectGetMidX(circleSelectorRect), CGRectGetMidY(circleSelectorRect), noc_floorCGFloat(CGRectGetWidth(circleSelectorRect) / 2.f), noc_radians(smallerAngle), noc_radians(biggerAngle), NO);
    
    // add shadow
    CGContextSetShadowWithColor(context, CGSizeMake(0.f, 0.f), self.shadowWidth, self.shadowColor.CGColor);
    
    // draw everything
    CGContextStrokePath(context);
}

#pragma mark - Handling touches

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *hitView = [super hitTest:point withEvent:event];
    
    // after dot selection continue with our view
    if (self.tappedCircleDot) {
        return hitView;
    }
    
    // if touchesBegan in our view
    if (!self.tappedCircleDot) {
        for (NOSELCircleDot *dot in self.dots) {
            // don't handle dots which are disabled to move
            if (!dot.userInteractionEnabled) {
                continue;
            }
            // make sure the dot is nearby
            if (ABS(point.x - dot.center.x) < self.dotRadius && ABS(point.y - dot.center.y) < self.dotRadius) {
                self.tappedCircleDot = dot;
                
                return hitView;
            }
        }
    }
    
    // if not handled then we didn't select real dot
    return nil;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (self.tappedCircleDot) {
        if ([self.delegate respondsToSelector:@selector(circleSelector:beganUpdatingDotPosition:)]) {
            [self.delegate circleSelector:self beganUpdatingDotPosition:self.tappedCircleDot];
        }
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if (self.tappedCircleDot) {
        CGPoint touchLocation = [[[event allTouches] anyObject] locationInView:self];
        [self placeDot:self.tappedCircleDot nearPoint:touchLocation];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (self.tappedCircleDot) {
        CGPoint touchLocation = [[[event allTouches] anyObject] locationInView:self];
        [self placeDot:self.tappedCircleDot nearPoint:touchLocation];
        
        [self informTouchesEnded];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [self informTouchesEnded];
}

#pragma mark - Dot placing

- (void)placeDot:(NOSELCircleDot *)dot nearPoint:(CGPoint)point {
    CGFloat normalizedAngleInDegrees = [NOSELMath normalizedAngleInDegreesFromCircleSelectorRect:self.circleSelectorRect nearPoint:point];
    int minAngle = nosel_intValue(dot.minAngle), maxAngle = nosel_intValue(dot.maxAngle), angle = nosel_intValue(dot.angle), newAngle = nosel_intValue(normalizedAngleInDegrees);
    BOOL circleRotated = NO;
    
    // if dot crossed the max/min values, don't move it
    if ([self isDotAngleCrossingMinMaxValues:newAngle dot:dot maxAngle:maxAngle minAngle:minAngle normalizedAngleInDegrees:&normalizedAngleInDegrees circleRotated:&circleRotated]) {
        return;
    }
    
    // don't allow to cycle
    if ((angle == minAngle || angle == maxAngle) && (newAngle < minAngle || newAngle > maxAngle)) {
        return;
    }
    if ((dot.angle < minAngle + 45 && newAngle > maxAngle - 45) || (dot.angle > maxAngle - 45 && newAngle < minAngle + 45)) {
        circleRotated = YES;
    }
    
    [self updateDotAngle:dot fromAngle:angle toAngle:newAngle minAngle:minAngle maxAngle:maxAngle circleRotated:circleRotated normalizedAngleInDegrees:normalizedAngleInDegrees];
}

- (void)updateDotAngle:(NOSELCircleDot *)dot fromAngle:(int)oldAngle toAngle:(int)newAngle minAngle:(int)minAngle maxAngle:(int)maxAngle circleRotated:(BOOL)circleRotated normalizedAngleInDegrees:(CGFloat)normalizedAngleInDegrees {
    if (oldAngle != newAngle) {
        
        // forbid to cycle if requested
        if (circleRotated && !self.allowsCycling) {
            return;
        }
        
        [dot setAngle:normalizedAngleInDegrees];
        // inform the delegate about the change
        if ([self.delegate respondsToSelector:@selector(circleSelector:updatedDot:)]) {
            [self.delegate circleSelector:self updatedDot:dot];
        }
        // update the view
        BOOL viewCouldJumpBetweenProhibitedArea = (oldAngle == minAngle || oldAngle == maxAngle) || circleRotated;
        if (viewCouldJumpBetweenProhibitedArea) {
            [self setNeedsDisplay];
        } else {
            [self setNeedsDisplayInRect:CGRectUnion([NOSELMath dotRectWithAngle:normalizedAngleInDegrees circleSelectorRect:self.circleSelectorRect dotRadius:self.dotRadius], [NOSELMath dotRectWithAngle:oldAngle circleSelectorRect:self.circleSelectorRect dotRadius:self.dotRadius])];
        }
    }
}

- (void)updateDotPosition:(NOSELCircleDot *)dot {
    CGRect frame = [NOSELMath dotRectWithAngle:dot.angle circleSelectorRect:self.circleSelectorRect dotRadius:self.dotRadius];
    [dot setFrame:frame];
}

- (BOOL)isDotAngleCrossingMinMaxValues:(int)angle dot:(NOSELCircleDot *)dot maxAngle:(int)maxAngle minAngle:(int)minAngle normalizedAngleInDegrees:(CGFloat *)normalizedAngleInDegrees circleRotated:(BOOL *)circleRotated {
    BOOL isInForbiddenRange = (angle > maxAngle) || (angle < minAngle);
    if (isInForbiddenRange) {
        // set to closest location or ignore if equal
        int differenceToMax = [NOSELMath normalizeAngle:(angle - maxAngle)];
        int differenceToMin = [NOSELMath normalizeAngle:(minAngle - angle)];
        if (differenceToMax == differenceToMin) {
            return YES;
        } else if (differenceToMax < differenceToMin) {
            *normalizedAngleInDegrees = dot.maxAngle;
            *circleRotated = YES;
        } else {
            *normalizedAngleInDegrees = dot.minAngle;
            *circleRotated = YES;
        }
    }
    
    return NO;
}

#pragma mark - Helpers

- (void)informTouchesEnded {
    if (self.tappedCircleDot) {
        if ([self.delegate respondsToSelector:@selector(circleSelector:endedUpdatingDotPosition:)]) {
            [self.delegate circleSelector:self endedUpdatingDotPosition:self.tappedCircleDot];
        }
        self.tappedCircleDot = nil;
    }
}

#pragma mark - Logging

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p, %@: %d, %@: %ld, %@: %f, %@: %@, %@: %@>",
            NSStringFromClass([self class]), self,
            NSStringFromSelector(@selector(allowsCycling)), self.allowsCycling,
            NSStringFromSelector(@selector(numberOfDots)), (long)self.numberOfDots,
            NSStringFromSelector(@selector(dotRadius)), self.dotRadius,
            NSStringFromSelector(@selector(dots)), self.dots,
            NSStringFromSelector(@selector(dotConnections)), self.dotConnections];
}

@end
