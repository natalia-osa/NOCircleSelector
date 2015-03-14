//
//  NOSELExampleView.h
//  NOCircleSelector
//
//  Created by Natalia Osiecka on 30.9.2014.
//  Copyright (c) 2014 iOskApps. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NOSELCircleSelector.h"

@interface NOSELExampleView : UIView

@property (nonatomic, readonly) NOSELCircleSelector *circleSelector;
@property (nonatomic, readonly) NOSELCircleSelector *smallCircleSelector;
@property (nonatomic, readonly) UILabel *valueLabel;
@property (nonatomic) CAGradientLayer *gradientLayer;

@end
