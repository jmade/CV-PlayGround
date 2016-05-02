//
//  JMSnapFlowCollectionViewController.h
//  CV PlayGround
//
//  Created by Justin Madewell on 5/25/14.
//  Copyright (c) 2014 Justin Madewell. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JMSnapFlowCollectionViewController : UICollectionViewController

@property (nonatomic, strong) NSString *selectedCell;
@property (nonatomic, strong) NSDictionary *selectedDictionary;
@property (nonatomic, strong) NSArray *cellValues;
@property (nonatomic, assign) NSInteger cellCount;

@end
