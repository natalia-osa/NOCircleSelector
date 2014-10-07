//
//  ExampleViewController.m
//  NOCircleSelector
//
//  Created by Natalia Osiecka on 30.9.2014.
//  Copyright (c) 2014 Natalia Osiecka. All rights reserved.
//

#import "ExampleViewController.h"
// Views
#import "ExampleView.h"

@interface ExampleViewController () <NOCircleSelectorDelegate>

@property (nonatomic, weak, readonly) ExampleView *aView;

@end

typedef NS_ENUM(NSUInteger, ExampleCircleDot) {
    ExampleCircleDotStart,
    ExampleCircleDotValue,
    ExampleCircleDotEnd,
    ExampleCircleDotValue2,
};

typedef NS_ENUM(NSUInteger, ExampleCircleSelector) {
    ExampleCircleSelectorBig,
    ExampleCircleSelectorSmall,
    ExampleCircleSelectorCount,
};

#define bigMaxAngle 270.f
#define bigMinAngle 0.f
#define smallMaxAngle 310.f

@implementation ExampleViewController

#pragma mark - View lifecycle

- (void)loadView {
    CGRect rect = [[UIScreen mainScreen] applicationFrame];
    ExampleView *view = [[ExampleView alloc] initWithFrame:rect];
    [view setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    
    // local for easier access
    _aView = view;
    self.view = view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_aView.valueLabel setHidden:YES];
    
    [_aView.circleSelector setDelegate:self];
    [_aView.circleSelector setTag:ExampleCircleSelectorBig];
    [_aView.circleSelector setNumberOfDots:3];
    [_aView.circleSelector setDotRadius:30.f];
    
    [_aView.smallCircleSelector setDelegate:self];
    [_aView.smallCircleSelector setTag:ExampleCircleSelectorSmall];
    [_aView.smallCircleSelector setNumberOfDots:4];
    [_aView.smallCircleSelector setDotRadius:15.f];
}

#pragma mark - NOCircleSelectorDelegate

- (void)circleSelector:(NOCircleSelector *)circleSelector changedDots:(NSArray *)dots {
    if (circleSelector.tag == ExampleCircleSelectorBig) {
        NOCircleDot *dot1 = [dots objectAtIndex:0];
        [dot1 setTag:ExampleCircleDotStart];
        [dot1 setLineColor:[UIColor redColor]];
        [dot1 setUserInteractionEnabled:NO];
        [dot1 setAngle:bigMinAngle];
        [dot1.textLabel setFont:[UIFont systemFontOfSize:10.f]];
        
        NOCircleDot *dot2 = [dots objectAtIndex:1];
        [dot2 setTag:ExampleCircleDotValue];
        [dot2 setLineColor:[UIColor redColor]];
        [dot2 setAngle:45.f];
        [dot2 setMinAngle:bigMinAngle];
        [dot2 setMaxAngle:bigMaxAngle];
        [dot2.textLabel setTextColor:[UIColor redColor]];
        
        NOCircleDot *dot3 = [dots objectAtIndex:2];
        [dot3 setTag:ExampleCircleDotEnd];
        [dot3 setLineColor:[UIColor redColor]];
        [dot3 setUserInteractionEnabled:NO];
        [dot3 setAngle:bigMaxAngle];
        [dot3.textLabel setFont:[UIFont systemFontOfSize:10.f]];
        [dot3.imageView setImage:[UIImage imageNamed:@"girl"]];
        
        // set the order of dots
        [circleSelector bringSubviewToFront:dot2];
    } else {
        NOCircleDot *dot1 = [dots objectAtIndex:0];
        [dot1 setTag:ExampleCircleDotStart];
        [dot1 setFillColor:[UIColor lightGrayColor]];
        [dot1 setLineColor:[UIColor darkGrayColor]];
        [dot1 setUserInteractionEnabled:NO];
        [dot1 setAngle:bigMinAngle];
        
        NOCircleDot *dot2 = [dots objectAtIndex:1];
        [dot2 setTag:ExampleCircleDotValue];
        [dot2 setFillColor:[UIColor redColor]];
        [dot2 setAngle:90.f];
        [dot2 setMinAngle:bigMinAngle];
        
        NOCircleDot *dot3 = [dots objectAtIndex:2];
        [dot3 setTag:ExampleCircleDotValue2];
        [dot3 setFillColor:[UIColor redColor]];
        [dot3 setAngle:210.f];
        [dot3 setMaxAngle:smallMaxAngle];
        
        NOCircleDot *dot4 = [dots objectAtIndex:3];
        [dot4 setTag:ExampleCircleDotEnd];
        [dot4 setFillColor:[UIColor lightGrayColor]];
        [dot4 setLineColor:[UIColor darkGrayColor]];
        [dot4 setUserInteractionEnabled:NO];
        [dot4 setAngle:smallMaxAngle];
        
        // set the order of dots
        [circleSelector sendSubviewToBack:dot1];
        [circleSelector sendSubviewToBack:dot4];
    }
}

- (void)circleSelector:(NOCircleSelector *)circleSelector changedDotConnections:(NSArray *)dotConnections {
    if (circleSelector.tag == ExampleCircleSelectorBig) {
        for (NOCircleDotConnection *dotConnection in dotConnections) {
            if ([dotConnection dotConnectionBeetweenTag1:ExampleCircleDotStart tag2:ExampleCircleDotValue]) {
                [dotConnection setLineWidth:5.f];
            } else if ([dotConnection dotConnectionBeetweenTag1:ExampleCircleDotStart tag2:ExampleCircleDotEnd]) {
                [dotConnection setConnectionColor:[UIColor clearColor]];
            } // rest is standard
        }
    } else {
        for (NOCircleDotConnection *dotConnection in dotConnections) {
            if ([dotConnection dotConnectionBeetweenTag1:ExampleCircleDotValue tag2:ExampleCircleDotValue2]) {
                [dotConnection setConnectionColor:[UIColor blueColor]];
                [dotConnection setLineWidth:4.f];
            } else if ([dotConnection dotConnectionBeetweenTag1:ExampleCircleDotStart tag2:ExampleCircleDotEnd]) {
                [dotConnection setConnectionColor:[UIColor clearColor]];
            } else {
                [dotConnection setConnectionColor:[UIColor darkGrayColor]];
            }
        }
    }
}

- (void)circleSelector:(NOCircleSelector *)circleSelector updatedDot:(NOCircleDot *)dot {
    if (circleSelector.tag == ExampleCircleSelectorBig) {
        if (dot.tag == ExampleCircleDotValue) {
            NSString *text = [NSString stringWithFormat:@"%ld", (long)[self valueForAngle:dot.angle maxAngle:bigMaxAngle maxValue:500.f]];
            [dot.textLabel setText:text];
            [_aView.valueLabel setText:text];
//        } else if (dot.tag == ExampleCircleDotEnd) {
//            [dot.textLabel setText:NSLocalizedString(@"MAX", nil)];
//        } else if (dot.tag == ExampleCircleDotStart) {
//            [dot.textLabel setText:NSLocalizedString(@"MIN", nil)];
        }
    } else {
        NSString *text = [NSString stringWithFormat:@"%ld", (long)[self valueForAngle:dot.angle maxAngle:smallMaxAngle maxValue:10.f]];
        [dot.textLabel setText:text];
        [_aView.valueLabel setText:text];
        
        if (dot.tag == ExampleCircleDotValue) { // dot is the lower one
            NOCircleDot *dot2 = [self dotWithTag:ExampleCircleDotValue2 fromDots:_aView.smallCircleSelector.dots];
            dot2.minAngle = dot.angle;
            dot.maxAngle = dot2.angle;
        } else if (dot.tag == ExampleCircleDotValue2) { // dot is the higher one
            NOCircleDot *dot1 = [self dotWithTag:ExampleCircleDotValue fromDots:_aView.smallCircleSelector.dots];
            dot1.maxAngle = dot.angle;
            dot.minAngle = dot1.angle;
        }
    }
}

- (void)circleSelector:(NOCircleSelector *)circleSelector beganUpdatingDotPosition:(NOCircleDot *)dot {
    [_aView.valueLabel setHidden:NO];
    [_aView.valueLabel setText:[NSString stringWithFormat:@"%ld", (long)(circleSelector.tag == ExampleCircleSelectorBig ? [self valueForAngle:dot.angle maxAngle:bigMaxAngle maxValue:500.f] : [self valueForAngle:dot.angle maxAngle:smallMaxAngle maxValue:10.f])]];
}

- (void)circleSelector:(NOCircleSelector *)circleSelector endedUpdatingDotPosition:(NOCircleDot *)dot {
    [_aView.valueLabel setHidden:YES];
}

#pragma mark - Helpers

- (NSInteger)valueForAngle:(CGFloat)angle maxAngle:(CGFloat)maxAngle maxValue:(CGFloat)maxValue {
    return floorf(maxValue * angle / maxAngle);
}

- (NOCircleDot *)dotWithTag:(NSUInteger)tag fromDots:(NSArray *)dots {
    for (NOCircleDot *dot in dots) {
        if (dot.tag == tag) {
            return dot;
        }
    }
    
    return nil;
}

@end
