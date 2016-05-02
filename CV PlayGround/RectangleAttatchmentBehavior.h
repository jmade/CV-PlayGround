//
//  RectangleAttatchmentBehavior.h
//  CV PlayGround
//
//  Created by Justin Madewell on 5/28/14.
//  Copyright (c) 2014 Justin Madewell. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RectangleAttatchmentBehavior : UIDynamicBehavior

-(instancetype)initWithItem:(id <UIDynamicItem>)item point:(CGPoint)p;
-(void)updateAttatchmentLocation:(CGPoint)p;

@end
