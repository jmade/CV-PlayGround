//
//  JMWheelLayout.h
//  CV PlayGround
//
//  Created by Justin Madewell on 5/17/14.
//  Copyright (c) 2014 Justin Madewell. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JMWheelLayout : UICollectionViewFlowLayout

@property (nonatomic, strong) NSMutableSet *insertIndexPaths;
@property (nonatomic, strong) NSMutableSet *deleteIndexPaths;
@property (nonatomic, assign) CGPoint center;
@property (nonatomic, assign) NSInteger cellCount;
@property (nonatomic, assign) NSInteger orientationInt;
@property (nonatomic, assign) NSInteger lastOInt;

@property (nonatomic, assign) NSInteger activeInteger;

@end
