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

@implementation ExampleViewController

- (instancetype)init {
    if (self == [super init]) {
        self.title = NSLocalizedString(@"Example 1", nil);
        self.tabBarItem.image = [UIImage imageNamed:@"1"];
    }
    
    return self;
}

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
    
    [_aView.circleSelector setDelegate:self];
    [_aView.circleSelector setNumberOfDots:3];
    [_aView.circleSelector setDotRadius:30.f];
    
    [_aView.smallCircleSelector setDelegate:self];
    [_aView.smallCircleSelector setNumberOfDots:4];
    [_aView.smallCircleSelector setDotRadius:15.f];
}

- (void)circleSelector:(NOCircleSelector *)circleSelector changedDots:(NSArray *)dots {
    CGFloat angle = 0.f;
    for (NOCircleDot *dot in dots) {
        [dot setAngle:angle];
        angle += 90.f;
    }
}

- (void)circleSelector:(NOCircleSelector *)circleSelector updatedDot:(NOCircleDot *)dot {
    [dot.textLabel setText:[NSString stringWithFormat:@"%ld", (long)[NOCircleDot valueForAngle:dot.angle maxAngle:360 maxValue:10.f minAngle:0.f minValue:0.f]]];
}

@end
