//
//  JMSnapFlowLayout.h
//  CV PlayGround
//
//  Created by Justin Madewell on 5/26/14.
//  Copyright (c) 2014 Justin Madewell. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JMSnapFlowLayout : UICollectionViewFlowLayout

@property (nonatomic, strong) NSMutableSet *insertIndexPaths;
@property (nonatomic, strong) NSMutableSet *deleteIndexPaths;
@property (nonatomic, assign) CGPoint center;
@property (nonatomic, assign) NSInteger cellCount;

@property (nonatomic, assign) NSInteger activeInteger;

@end
