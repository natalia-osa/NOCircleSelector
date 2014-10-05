//
//  ExampleView.h
//  NOCircleSelector
//
//  Created by Natalia Osiecka on 30.9.2014.
//  Copyright (c) 2014 Natalia Osiecka. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NOCircleSelector.h"

@interface ExampleView : UIView

@property (nonatomic, strong, readonly) NOCircleSelector *circleSelector;
@property (nonatomic, strong, readonly) NOCircleSelector *smallCircleSelector;
@property (nonatomic, strong, readonly) UILabel *valueLabel;

@end
