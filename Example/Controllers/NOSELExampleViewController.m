//
//  NOSELExampleViewController.m
//  NOCircleSelector
//
//  Created by Natalia Osiecka on 30.9.2014.
//  Copyright (c) 2014 iOskApps. All rights reserved.
//

#import "NOSELExampleViewController.h"
// Views
#import "NOSELExampleView.h"

@interface NOSELExampleViewController () <NOSELCircleSelectorDelegate>

@property (nonatomic, weak, readonly) NOSELExampleView *aView;

@end

@implementation NOSELExampleViewController

- (instancetype)init {
    if (self = [super init]) {
        self.title = NSLocalizedString(@"Example 1", nil);
        self.tabBarItem.image = [UIImage imageNamed:@"1"];
    }
    
    return self;
}

#pragma mark - View lifecycle

- (void)loadView {
    CGRect rect = [[UIScreen mainScreen] applicationFrame];
    NOSELExampleView *view = [[NOSELExampleView alloc] initWithFrame:rect];
    [view setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    
    // local for easier access
    _aView = view;
    self.view = view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.aView.circleSelector setDelegate:self];
    [self.aView.circleSelector setNumberOfDots:3];
    [self.aView.circleSelector setDotRadius:30.f];
    
    [self.aView.smallCircleSelector setDelegate:self];
    [self.aView.smallCircleSelector setNumberOfDots:4];
    [self.aView.smallCircleSelector setDotRadius:15.f];
}

- (void)circleSelector:(NOSELCircleSelector *)circleSelector changedDots:(NSArray *)dots {
    CGFloat angle = 0.f;
    for (NOSELCircleDot *dot in dots) {
        [dot setAngle:angle];
        angle += 90.f;
    }
}

- (void)circleSelector:(NOSELCircleSelector *)circleSelector updatedDot:(NOSELCircleDot *)dot {
    [dot.textLabel setText:[NSString stringWithFormat:@"%ld", (long)[NOSELCircleDot valueForAngle:dot.angle maxAngle:360 maxValue:10.f minAngle:0.f minValue:0.f]]];
}

@end
