//
//  OptionsViewController.h
//  CV PlayGround
//
//  Created by Justin Madewell on 6/13/14.
//  Copyright (c) 2014 Justin Madewell. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OptionsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIStepper *timeStepper;

@property (nonatomic, assign) CGFloat speedValue;

@property (nonatomic, strong) NSString *speedString;

@end
