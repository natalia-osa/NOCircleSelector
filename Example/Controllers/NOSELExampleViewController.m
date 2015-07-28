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
    [self.aView.circleSelector setDotRadius:30.f];
    [self.aView.circleSelector setLineWidth:5.f];
    [self.aView.circleSelector setLineColor:[UIColor redColor]];
    [self.aView.circleSelector setFillColor:[UIColor colorWithRed:1.f green:0.f blue:0.f alpha:0.7f]];
    [self.aView.circleSelector setShadowWidth:8];
    [self.aView.circleSelector setShadowColor:[UIColor whiteColor]];
    [self.aView.circleSelector setNumberOfDots:3];
    
    [self.aView.smallCircleSelector setDelegate:self];
    [self.aView.smallCircleSelector setDotRadius:15.f];
    [self.aView.smallCircleSelector setLineWidth:4.f];
    [self.aView.smallCircleSelector setLineColor:[UIColor redColor]];
    [self.aView.smallCircleSelector setShadowWidth:5];
    [self.aView.smallCircleSelector setShadowColor:[UIColor whiteColor]];
    [self.aView.smallCircleSelector setNumberOfDots:4];
}

- (void)circleSelector:(NOSELCircleSelector *)circleSelector changedDots:(NSArray *)dots {
    CGFloat angle = 0.f;
    for (NOSELCircleDot *dot in dots) {
        [dot setLineColor:[UIColor redColor]];
        [dot setLineWidth:2.f];
        [dot setAngle:angle];
        angle += 90.f;
    }
}

- (void)circleSelector:(NOSELCircleSelector *)circleSelector updatedDot:(NOSELCircleDot *)dot {
    [dot.textLabel setText:[NSString stringWithFormat:@"%ld", (long)[NOSELCircleDot valueForAngle:dot.angle maxAngle:360 maxValue:10.f minAngle:0.f minValue:0.f]]];
}

@end
