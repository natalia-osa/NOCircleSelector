//
//  NOSELAdvancedExampleViewController.m
//  NOCircleSelector
//
//  Created by Natalia Osiecka on 08.10.2014.
//  Copyright (c) 2014 iOskApps. All rights reserved.
//

#import "NOSELAdvancedExampleViewController.h"
// Views
#import "NOSELAdvancedExampleView.h"
#import "NOSELExampleCircleDot.h"

@interface NOSELAdvancedExampleViewController () <NOSELCircleSelectorDelegate>

@property (nonatomic, weak, readonly) NOSELAdvancedExampleView *aView;

@end

#define bigMaxAngle 270.f
#define bigMinAngle 0.f
#define smallMaxAngle 310.f

typedef NS_ENUM(NSUInteger, ExampleCircleDotKind) {
    ExampleCircleDotKindStart,
    ExampleCircleDotKindValue,
    ExampleCircleDotKindEnd,
    ExampleCircleDotKindValue2,
};

typedef NS_ENUM(NSUInteger, ExampleCircleSelector) {
    ExampleCircleSelectorBig,
    ExampleCircleSelectorSmall,
    ExampleCircleSelectorMedium,
    ExampleCircleSelectorCount,
};

@implementation NOSELAdvancedExampleViewController

- (instancetype)init {
    if (self = [super init]) {
        self.title = NSLocalizedString(@"Example 2", nil);
        self.tabBarItem.image = [UIImage imageNamed:@"2"];
    }
    
    return self;
}

#pragma mark - View lifecycle

- (void)loadView {
    CGRect rect = [[UIScreen mainScreen] applicationFrame];
    NOSELAdvancedExampleView *view = [[NOSELAdvancedExampleView alloc] initWithFrame:rect];
    [view setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    
    // local for easier access
    _aView = view;
    self.view = view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.aView.valueLabel setHidden:YES];
    
    [self.aView.circleSelector setDelegate:self];
    [self.aView.circleSelector setTag:ExampleCircleSelectorBig];
    [self.aView.circleSelector setAllowsCycling:NO];
    [self.aView.circleSelector setNumberOfDots:3];
    [self.aView.circleSelector setDotRadius:30.f];
    
    [self.aView.smallCircleSelector setDelegate:self];
    [self.aView.smallCircleSelector setTag:ExampleCircleSelectorSmall];
    [self.aView.smallCircleSelector setNumberOfDots:4];
    [self.aView.smallCircleSelector setDotRadius:10.f];
    
    [self.aView.mediumCircleSelector setDelegate:self];
    [self.aView.mediumCircleSelector setTag:ExampleCircleSelectorMedium];
    [self.aView.mediumCircleSelector setNumberOfDots:7];
    [self.aView.mediumCircleSelector setDotRadius:15.f];
}

#pragma mark - NOCircleSelectorDelegate

- (Class)circleSelectorRequestsNOCircleDotClass:(NOSELCircleSelector *)circleSelector {
    return [NOSELExampleCircleDot class];
}

- (void)circleSelector:(NOSELCircleSelector *)circleSelector changedDots:(NSArray *)dots {
    CGFloat angle = 0.f;
    int counter = 0;
    
    for (NOSELCircleDot *dot in dots) {
        if (counter == 0) {
            [dot setTag:ExampleCircleDotKindStart];
            [dot setUserInteractionEnabled:NO];
        } else if (counter == dots.count - 1) {
            [dot setTag:ExampleCircleDotKindEnd];
            [dot setUserInteractionEnabled:NO];
        } else {
            [dot setTag:ExampleCircleDotKindValue];
        }
        
        if (circleSelector.tag == ExampleCircleSelectorSmall) {
            [dot.textLabel setFont:[UIFont systemFontOfSize:10.f]];
            switch (counter) {
                case 0: {
                    [dot setAngle:bigMinAngle];
                    [dot setFillColor:[UIColor whiteColor]];
                    [dot.textLabel setFont:[UIFont systemFontOfSize:8.f]];
                    break;
                } case 1: {
                    [dot setAngle:90.f];
                    [dot setMinAngle:bigMinAngle];
                    break;
                } case 2: {
                    [dot setTag:ExampleCircleDotKindValue2];
                    [dot setAngle:150.f];
                    [dot setMaxAngle:smallMaxAngle];
                    break;
                } case 3: {
                    [dot setAngle:smallMaxAngle];
                    [dot.imageView setImage:[UIImage imageNamed:@"girl"]];
                    [dot.textLabel setHidden:YES];
                    break;
                } default: {
                    break;
                }
            }
            
        } else if (circleSelector.tag == ExampleCircleSelectorMedium) {
            [dot setAngle:angle];
            
        } else if (circleSelector.tag == ExampleCircleSelectorBig) {
            switch (counter) {
                case 0: {
                    [dot setAngle:bigMinAngle];
                    break;
                } case 1: {
                    [dot setAngle:45.f];
                    [dot setMinAngle:bigMinAngle];
                    [dot setMaxAngle:bigMaxAngle];
                    break;
                } case 2: {
                    [dot setAngle:bigMaxAngle];
                } default: {
                    break;
                }
            }
        }
        
        // increment loop values
        angle += 60.f;
        counter += 1;
    }
    
    // set the order of dots
    if (circleSelector.tag == ExampleCircleSelectorBig) {
        if (dots.count > 2) {
            [circleSelector bringSubviewToFront:[dots objectAtIndex:1]];
        }
    } else if (circleSelector.tag == ExampleCircleSelectorSmall) {
        if (dots.count > 3) {
            [circleSelector sendSubviewToBack:[dots objectAtIndex:0]];
            [circleSelector sendSubviewToBack:[dots objectAtIndex:3]];
        }
    }
}

- (void)circleSelector:(NOSELCircleSelector *)circleSelector changedDotConnections:(NSArray *)dotConnections {
    for (NOSELCircleDotConnection *dotConnection in dotConnections) {
        [dotConnection setConnectionColor:[UIColor redColor]];
        
        if ((circleSelector.tag == ExampleCircleSelectorBig && [dotConnection dotConnectionBeetweenTag1:ExampleCircleDotKindStart tag2:ExampleCircleDotKindValue]) ||
            (circleSelector.tag == ExampleCircleSelectorSmall && [dotConnection dotConnectionBeetweenTag1:ExampleCircleDotKindValue tag2:ExampleCircleDotKindValue2])) {
            [dotConnection setLineWidth:5.f];
            if (circleSelector.tag == ExampleCircleSelectorSmall) {
                [dotConnection setConnectionColor:[UIColor whiteColor]];
            }
        } else if ([dotConnection dotConnectionBeetweenTag1:ExampleCircleDotKindStart tag2:ExampleCircleDotKindEnd]) {
            [dotConnection setConnectionColor:[UIColor clearColor]];
        }
    }
}

- (void)circleSelector:(NOSELCircleSelector *)circleSelector updatedDot:(NOSELCircleDot *)dot {
    if (dot.tag == ExampleCircleDotKindValue || dot.tag == ExampleCircleDotKindValue2) {
        //##OBJCLEAN_SKIP##
        NSString *text = [NSString stringWithFormat:@"%ld", (circleSelector.tag == ExampleCircleSelectorBig)
                                                        ? (long)[NOSELCircleDot valueForAngle:dot.angle maxAngle:bigMaxAngle maxValue:500.f minAngle:bigMinAngle minValue:0.f]
                                                        : (long)[NOSELCircleDot valueForAngle:dot.angle maxAngle:smallMaxAngle maxValue:10.f minAngle:bigMinAngle minValue:0.f]];
        //##OBJCLEAN_ENDSKIP##
        [dot.textLabel setText:text];
        [self.aView.valueLabel setText:text];
    } else if (dot.tag == ExampleCircleDotKindEnd) {
        [dot.textLabel setText:[NSString stringWithFormat:@"%d", (circleSelector.tag == ExampleCircleSelectorBig) ? 500 : 10]];
    } else if (dot.tag == ExampleCircleDotKindStart && circleSelector.tag != ExampleCircleSelectorMedium) {
        [dot.textLabel setText:@"0"];
        if (circleSelector.tag == ExampleCircleSelectorSmall) {
            [dot.textLabel setText:NSLocalizedString(@"MIN", nil)];
        }
    }
    
    if (circleSelector.tag == ExampleCircleSelectorSmall) {
        if (dot.tag == ExampleCircleDotKindValue) { // dot is the lower one
            NOSELCircleDot *dot2 = [NOSELCircleDot dotWithTag:ExampleCircleDotKindValue2 fromDots:self.aView.smallCircleSelector.dots];
            dot2.minAngle = dot.angle;
            dot.maxAngle = dot2.angle;
        } else if (dot.tag == ExampleCircleDotKindValue2) { // dot is the higher one
            NOSELCircleDot *dot1 = [NOSELCircleDot dotWithTag:ExampleCircleDotKindValue fromDots:self.aView.smallCircleSelector.dots];
            dot1.maxAngle = dot.angle;
            dot.minAngle = dot1.angle;
        }
    }
}

- (void)circleSelector:(NOSELCircleSelector *)circleSelector beganUpdatingDotPosition:(NOSELCircleDot *)dot {
    [self.aView.valueLabel setHidden:NO];
    //##OBJCLEAN_SKIP##
    [self.aView.valueLabel setText:[NSString stringWithFormat:@"%ld", (long)(circleSelector.tag == ExampleCircleSelectorBig
                                                                         ? [NOSELCircleDot valueForAngle:dot.angle maxAngle:bigMaxAngle maxValue:500.f minAngle:bigMinAngle minValue:0.f]
                                                                         : [NOSELCircleDot valueForAngle:dot.angle maxAngle:smallMaxAngle maxValue:10.f minAngle:bigMinAngle minValue:0.f])]];
    //##OBJCLEAN_ENDSKIP##
}

- (void)circleSelector:(NOSELCircleSelector *)circleSelector endedUpdatingDotPosition:(NOSELCircleDot *)dot {
    [self.aView.valueLabel setHidden:YES];
}

@end
