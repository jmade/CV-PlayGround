//
//  BottomAnchorBehavior.h
//  CV PlayGround
//
//  Created by Justin Madewell on 5/29/14.
//  Copyright (c) 2014 Justin Madewell. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BottomAnchorBehavior : UIDynamicBehavior

@property (nonatomic, assign) CGPoint currentAnchor;

@property (nonatomic, assign) CGPoint center;
@property (nonatomic, assign) CGPoint topLeft;
@property (nonatomic, assign) CGPoint topRight;
@property (nonatomic, assign) CGPoint bottomLeft;
@property (nonatomic, assign) CGPoint bottomRight;
@property (nonatomic, assign) CGPoint midTop;
@property (nonatomic, assign) CGPoint midBottom;


-(instancetype)initWithItem:(id <UIDynamicItem>)item point:(CGPoint)p;
-(void)updateAnchorLocation:(CGPoint)p;

@end
