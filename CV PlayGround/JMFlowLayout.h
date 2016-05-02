//
//  JMFlowLayout.h
//  CV PlayGround
//
//  Created by Justin Madewell on 5/14/14.
//  Copyright (c) 2014 Justin Madewell. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JMFlowLayout : UICollectionViewFlowLayout

@property (nonatomic, strong) NSMutableSet *insertedRowSet;
@property (nonatomic, strong) NSMutableSet *deletedRowSet;
@property (nonatomic, assign) CGPoint center;
@property (nonatomic, assign) NSInteger cellCount;



@end
