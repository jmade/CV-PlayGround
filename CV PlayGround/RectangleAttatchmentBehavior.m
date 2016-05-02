//
//  RectangleAttatchmentBehavior.m
//  CV PlayGround
//
//  Created by Justin Madewell on 5/28/14.
//  Copyright (c) 2014 Justin Madewell. All rights reserved.
//

#import "RectangleAttatchmentBehavior.h"

#define FREQUENCY 1.5
#define DAMPING 0.2

@interface RectangleAttatchmentBehavior ()

@property (nonatomic, assign) CGSize itemSize;

@end

@implementation RectangleAttatchmentBehavior

-(instancetype)initWithItem:(id<UIDynamicItem>)item point:(CGPoint)p
{
    if (self = [super init])
    {
        self.itemSize = [item bounds].size;
        
        CGFloat width = self.itemSize.width;
        CGFloat height = self.itemSize.height;
        
        CGPoint topLeft = CGPointMake(p.x - width / 2.0, p.y - height /2.0);
        CGPoint topRight = CGPointMake(p.x + width / 2.0, p.y - height /2.0);
        CGPoint bottomLeft = CGPointMake(p.x - width / 2.0, p.y + height /2.0);
        CGPoint bottomRight = CGPointMake(p.x + width / 2.0, p.y + height /2.0);
    
        UIAttachmentBehavior *attatchBehavior;
        
        attatchBehavior = [[UIAttachmentBehavior alloc] initWithItem:item attachedToAnchor:topLeft];
        [attatchBehavior setFrequency:FREQUENCY];
        [attatchBehavior setDamping:DAMPING];
        [self addChildBehavior:attatchBehavior];
        
        attatchBehavior = [[UIAttachmentBehavior alloc] initWithItem:item attachedToAnchor:topRight];
        [attatchBehavior setFrequency:FREQUENCY];
        [attatchBehavior setDamping:DAMPING];
        [self addChildBehavior:attatchBehavior];
        
        attatchBehavior = [[UIAttachmentBehavior alloc] initWithItem:item attachedToAnchor:bottomLeft];
        [attatchBehavior setFrequency:FREQUENCY];
        [attatchBehavior setDamping:DAMPING];
        [self addChildBehavior:attatchBehavior];
        
        attatchBehavior = [[UIAttachmentBehavior alloc] initWithItem:item attachedToAnchor:bottomRight];
        [attatchBehavior setFrequency:FREQUENCY];
        [attatchBehavior setDamping:DAMPING];
        [self addChildBehavior:attatchBehavior];
        
        NSLog(@"Current Anchor: %@",NSStringFromCGPoint(topLeft));
        
    }
    
   
    
    return self;
}



-(void)updateAttatchmentLocation:(CGPoint)p {
    
    NSLog(@"I Got Updated Here: %@",NSStringFromCGPoint(p));
    
    CGFloat width = self.itemSize.width;
    CGFloat height = self.itemSize.height;
    
    CGPoint topLeft = CGPointMake(p.x - width / 2.0, p.y - height /2.0);
    CGPoint topRight = CGPointMake(p.x + width / 2.0, p.y - height /2.0);
    CGPoint bottomLeft = CGPointMake(p.x - width / 2.0, p.y + height /2.0);
    CGPoint bottomRight = CGPointMake(p.x + width / 2.0, p.y + height /2.0);
    
    UIAttachmentBehavior *attatchBehavior;
    
    attatchBehavior = [[self childBehaviors] objectAtIndex:0];
    attatchBehavior.anchorPoint = topLeft;
    attatchBehavior = [[self childBehaviors] objectAtIndex:1];
    attatchBehavior.anchorPoint = topRight;
    attatchBehavior = [[self childBehaviors] objectAtIndex:2];
    attatchBehavior.anchorPoint = bottomLeft;
    attatchBehavior = [[self childBehaviors] objectAtIndex:3];
    attatchBehavior.anchorPoint = bottomRight;
    
   
    
}

@end
