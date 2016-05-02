//
//  JMMasterViewController.h
//  CV PlayGround
//
//  Created by Justin Madewell on 5/13/14.
//  Copyright (c) 2014 Justin Madewell. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JMDetailViewController;
@class JMCollectionViewController;

@interface JMMasterViewController : UITableViewController

@property (strong, nonatomic) JMDetailViewController *detailViewController;
@property (nonatomic, strong) JMCollectionViewController *collectViewController;
@property (nonatomic, strong) NSArray *appKeys;
@property (nonatomic, strong) NSDictionary *appDict;

@end
