//
//  JMCircleLayout.h
//  CV PlayGround
//
//  Created by Justin Madewell on 5/14/14.
//  Copyright (c) 2014 Justin Madewell. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JMCircleLayout : UICollectionViewLayout

@property (nonatomic, assign) CGPoint center;
@property (nonatomic, assign) CGFloat radius;
@property (nonatomic, assign) NSInteger cellCount;

@end
