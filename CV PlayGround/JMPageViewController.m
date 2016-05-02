//
//  JMPageViewController.m
//  CV PlayGround
//
//  Created by Justin Madewell on 5/29/14.
//  Copyright (c) 2014 Justin Madewell. All rights reserved.
//

#import "JMPageViewController.h"
#import "Colours.h"

@interface JMPageViewController ()

@end

@implementation JMPageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
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
    self.title = @"My Paged VC";
    self.view.backgroundColor = [UIColor goldenrodColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
