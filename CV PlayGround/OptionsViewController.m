//
//  OptionsViewController.m
//  CV PlayGround
//
//  Created by Justin Madewell on 6/13/14.
//  Copyright (c) 2014 Justin Madewell. All rights reserved.
//

#import "OptionsViewController.h"
#import "JMViewController.h"

@interface OptionsViewController ()

@property (nonatomic, strong) JMViewController *jmVC;

@end

@implementation OptionsViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //self.timeLabel.text = @"0";
   // self.jmVC = [[JMViewController alloc]init];

    NSNumber *speedNum = [NSNumber numberWithFloat:self.speedValue];
    NSString *speedString = [NSNumberFormatter localizedStringFromNumber:speedNum numberStyle:NSNumberFormatterDecimalStyle];
    
    self.timeLabel.text = speedString;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
       
        //
    }];
}
- (IBAction)timeStepperStepped:(UIStepper *)sender {
   
    NSUInteger value = sender.value;
    CGFloat originalValue = self.speedValue;
    CGFloat newValue = originalValue + value;
    self.speedValue = newValue;
    
    NSNumber *speedNum = [NSNumber numberWithFloat:newValue];
    NSString *speedString = [NSNumberFormatter localizedStringFromNumber:speedNum numberStyle:NSNumberFormatterDecimalStyle];
    
    self.timeLabel.text = speedString;
    
    
    
    NSLog(@"Stepper Value: %f",newValue);
    
   // NSNumber *timeNumber = [NSNumber nu]
   
    
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
