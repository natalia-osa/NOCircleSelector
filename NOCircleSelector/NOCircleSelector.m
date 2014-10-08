//
//  NOCircleSelector.m
//  NOCircleSelector
//
//  Created by Natalia Osiecka on 30.9.2014.
//  Copyright (c) 2014 Natalia Osiecka. All rights reserved.
//

#import "NOCircleSelector.h"

#define intValue(x) (int)floorf(x)

@interface NOCircleSelector ()

@property (nonatomic) CGRect circleSelectorRect;
@property (nonatomic) NOCircleDot *tappedCircleDot;

@end

@implementation NOCircleSelector

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
    
    _tappedCircleDot = nil;
    _numberOfDots = 0;
    _lineWidth = 1.f;
    _dotRadius = 10.f;
    _lineColor = [UIColor redColor];
    _fillColor = [UIColor clearColor];
}

#pragma mark - Setters / Getters

- (void)setNumberOfDots:(NSInteger)numberOfDots {
    _numberOfDots = numberOfDots;
    
    // create new dots
    NSMutableArray *mDots = [NSMutableArray new];
    for (NSInteger i = 0; i < numberOfDots; i++) {
        NOCircleDot *dot = [[NOCircleDot alloc] init];
        [dot setBackgroundColor:[self backgroundColor]];
        [mDots addObject:dot];
    }
    
    // create new dotConnections with default values
    NSMutableArray *mDotConnections = [NSMutableArray new];
    for (NSInteger i = 0; i < numberOfDots; i++) {
        NOCircleDotConnection *connection = [[NOCircleDotConnection alloc] init];
        [connection setLineWidth:_lineWidth];
        [connection setConnectionColor:_lineColor];
        [connection setStartDot:[mDots objectAtIndex:i]];
        if (mDots.count > (i + 1)) {
            [connection setEndDot:[mDots objectAtIndex:(i + 1)]];
        } else {
            [connection setEndDot:[mDots objectAtIndex:0]];
        }
        [mDotConnections addObject:connection];
    }
    
    // and call the setter of dots
    [self setDots:[mDots copy]];
    // update the connections
    [self setDotConnections:[mDotConnections copy]];
}

- (void)setDotConnections:(NSArray *)dotConnections {
    _dotConnections = dotConnections;
    
    // inform the delegate
    if ([_delegate respondsToSelector:@selector(circleSelector:changedDotConnections:)]) {
        [_delegate circleSelector:self changedDotConnections:_dotConnections];
    }
    
    // update the view
    [self setNeedsDisplay];
}

- (void)setDots:(NSArray *)dots {
    // firstly delete old dots
    for (NOCircleDot *dot in _dots) {
        [dot removeFromSuperview];
    }
    // update the dots
    _dots = dots;
    // now create new ones
    for (NOCircleDot *dot in _dots) {
        [self addSubview:dot];
    }
    
    // inform the delegate
    if ([_delegate respondsToSelector:@selector(circleSelector:changedDots:)]) {
        [_delegate circleSelector:self changedDots:dots];
        // then call update on each dot
        if ([_delegate respondsToSelector:@selector(circleSelector:updatedDot:)]) {
            for (NOCircleDot *dot in dots) {
                [_delegate circleSelector:self updatedDot:dot];
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

#pragma mark - Drawing code

- (void)layoutSubviews {
    [super layoutSubviews];
    
    for (NOCircleDot *dot in _dots) {
        [self updateDotPosition:dot];
    }
}

- (void)drawRect:(CGRect)rect {
    // get variables
    CGRect frame = self.bounds;
    CGFloat sideLength = MIN(CGRectGetWidth(frame), CGRectGetHeight(frame)) / 2.f - _dotRadius;
    _circleSelectorRect = CGRectMake(CGRectGetMidX(frame) - sideLength, CGRectGetMidY(frame) - sideLength, sideLength * 2, sideLength * 2);
    
    [self setNeedsLayout];
    [self drawCircle];
}

- (void)drawCircle {
    // setup context
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClearRect(context, self.bounds);
    
    // draw the circle using personalized connections
    for (NOCircleDotConnection *dotConnection in _dotConnections) {
        CGContextSetLineWidth(context, dotConnection.lineWidth);
        CGContextBeginPath(context);
        CGContextSetStrokeColorWithColor(context, dotConnection.connectionColor.CGColor);
        CGFloat smallerAngle = [self normalizeAngle:MIN(dotConnection.startDot.angle, dotConnection.endDot.angle) - 90];
        CGFloat biggerAngle = [self normalizeAngle:MAX(dotConnection.startDot.angle, dotConnection.endDot.angle) - 90];
        CGContextAddArc(context, CGRectGetMidX(_circleSelectorRect), CGRectGetMidY(_circleSelectorRect), floorf(CGRectGetWidth(_circleSelectorRect) / 2.f), radians(smallerAngle), radians(biggerAngle), NO);
        CGContextStrokePath(context);
    }
    
    CGContextSetLineWidth(context, _lineWidth);
    
    // draw circle fillColor
    if (_fillColor != [UIColor clearColor]) {
        CGContextSaveGState(context);
        CGContextAddEllipseInRect(context, _circleSelectorRect);
        CGContextClip(context);
        CGContextSetFillColorWithColor(context, _fillColor.CGColor);
        CGContextFillRect(context, _circleSelectorRect);
        CGContextRestoreGState(context);
    }
    
    // clear the circle inside each dot
    for (NOCircleDot *dot in _dots) {
        CGContextSaveGState(context);
        CGRect clippingEllipseRect = [self dotRectWithAngle:dot.angle];
        CGContextAddEllipseInRect(context, clippingEllipseRect);
        CGContextClip(context);
        CGContextClearRect(context, clippingEllipseRect);
        CGContextRestoreGState(context);
    }
    
    // draw background color
    CGContextSetFillColorWithColor(context, self.backgroundColor.CGColor);
    CGContextFillRect(context, self.bounds);
}

#pragma mark - Handling touches

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *hitView = [super hitTest:point withEvent:event];
    
    // after dot selection continue with our view
    if (_tappedCircleDot) {
        return hitView;
    }
    
    // if touchesBegan in our view
    if (!_tappedCircleDot) {// && hitView == self) {
        for (NOCircleDot *dot in _dots) {
            // don't handle dots which are disabled to move
            if (!dot.userInteractionEnabled) {
                continue;
            }
            // make sure the dot is nearby
            if (ABS(point.x - dot.center.x) < _dotRadius && ABS(point.y - dot.center.y) < _dotRadius) {
                _tappedCircleDot = dot;
                
                return hitView;
            }
        }
    }
    
    // if not handled then we didn't select real dot
    return nil;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (_tappedCircleDot) {
        if ([_delegate respondsToSelector:@selector(circleSelector:beganUpdatingDotPosition:)]) {
            [_delegate circleSelector:self beganUpdatingDotPosition:_tappedCircleDot];
        }
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if (_tappedCircleDot) {
        CGPoint touchLocation = [[[event allTouches] anyObject] locationInView:self];
        [self placeDot:_tappedCircleDot nearPoint:touchLocation];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (_tappedCircleDot) {
        CGPoint touchLocation = [[[event allTouches] anyObject] locationInView:self];
        [self placeDot:_tappedCircleDot nearPoint:touchLocation];
        
        if ([_delegate respondsToSelector:@selector(circleSelector:endedUpdatingDotPosition:)]) {
            [_delegate circleSelector:self endedUpdatingDotPosition:_tappedCircleDot];
        }
        _tappedCircleDot = nil;
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    if (_tappedCircleDot) {
        if ([_delegate respondsToSelector:@selector(circleSelector:endedUpdatingDotPosition:)]) {
            [_delegate circleSelector:self endedUpdatingDotPosition:_tappedCircleDot];
        }
        _tappedCircleDot = nil;
    }
}

#pragma mark - Dot placing

- (void)placeDot:(NOCircleDot *)dot nearPoint:(CGPoint)point {
    CGPoint middleCirclePoint = CGPointMake(CGRectGetMidX(_circleSelectorRect), CGRectGetMidY(_circleSelectorRect));
    CGFloat deltaY = middleCirclePoint.y - point.y;
    CGFloat deltaX = middleCirclePoint.x - point.x;
    CGFloat angleInDegrees = [self normalizeAngle:(atan2f(deltaY, deltaX) * 180 / M_PI - 90)];
    int minAngle = intValue(dot.minAngle), maxAngle = intValue(dot.maxAngle), angle = intValue(dot.angle), newAngle = intValue(angleInDegrees);
    BOOL circleRotated = NO;
    
    // don't allow to pass min / max values
    BOOL isInForbiddenRange = (newAngle > maxAngle) || (newAngle < minAngle);
    if (isInForbiddenRange) {
        // set to closest location or ignore if equal
        int differenceToMax = [self normalizeAngle:(newAngle - maxAngle)];
        int differenceToMin = [self normalizeAngle:(minAngle - newAngle)];
        if (differenceToMax == differenceToMin) {
            return;
        } else if (differenceToMax < differenceToMin) {
            angleInDegrees = dot.maxAngle;
            circleRotated = YES;
        } else {
            angleInDegrees = dot.minAngle;
            circleRotated = YES;
        }
    }
    
    // don't allow to cycle
    if ((angle == minAngle || angle == maxAngle) && (newAngle < minAngle || newAngle > maxAngle)) {
        return;
    }
    if ((dot.angle < minAngle + 45 && newAngle > maxAngle - 45) || (dot.angle > maxAngle - 45 && newAngle < minAngle + 45)) {
        circleRotated = YES;
    }
    // update the angle
    if (angle != newAngle) {
        [dot setAngle:angleInDegrees];
        // inform the delegate about the change
        if ([_delegate respondsToSelector:@selector(circleSelector:updatedDot:)]) {
            [_delegate circleSelector:self updatedDot:dot];
        }
        // update the view
        BOOL viewCouldJumpBetweenProhibitedArea = (angle == minAngle || angle == maxAngle) || circleRotated;
        if (viewCouldJumpBetweenProhibitedArea) {
            [self setNeedsDisplay];
        } else {
            [self setNeedsDisplayInRect:CGRectUnion([self dotRectWithAngle:angleInDegrees], [self dotRectWithAngle:angle])];
        }
    }
}

- (void)updateDotPosition:(NOCircleDot *)dot {
    CGRect frame = [self dotRectWithAngle:dot.angle];
    [dot setFrame:frame];
}

- (CGRect)dotRectWithAngle:(CGFloat)angle {
    CGFloat radians = radians(-angle);
    CGFloat radius = CGRectGetWidth(_circleSelectorRect) / 2.f;
    CGPoint middleCirclePoint = CGPointMake(CGRectGetMidX(_circleSelectorRect), CGRectGetMidY(_circleSelectorRect));
    
    CGPoint center = CGPointMake(middleCirclePoint.x - radius * sin(radians), middleCirclePoint.y - radius * cos(radians));
    CGSize size = CGSizeMake(_dotRadius * 2, _dotRadius * 2);
    CGRect rect = CGRectIntegral(CGRectMake(center.x - size.width / 2, center.y - size.height / 2, size.width, size.height));
    
    return rect;
}

#pragma mark - Helpers

- (CGFloat)normalizeAngle:(CGFloat)angle {
    CGFloat normalizedAngle = intValue(angle) % 360;
    if (normalizedAngle < 0) {
        normalizedAngle = 360 + normalizedAngle;
    }
    
    return normalizedAngle;
}

@end
