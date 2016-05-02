//
//  BottomAnchorBehavior.m
//  CV PlayGround
//
//  Created by Justin Madewell on 5/29/14.
//  Copyright (c) 2014 Justin Madewell. All rights reserved.
//

#import "BottomAnchorBehavior.h"

#define FREQUENCY 0.25
#define DAMPING 0.25
#define LENGTH 0

@interface BottomAnchorBehavior ()

@property (nonatomic, assign) CGSize itemSize;

@end

@implementation BottomAnchorBehavior

-(instancetype)initWithItem:(id<UIDynamicItem>)item point:(CGPoint)p
{
    if (self = [super init])
    {
        self.itemSize = [item bounds].size;
        
        CGFloat W = self.itemSize.width/2.0;
        CGFloat H = self.itemSize.height/2.0;
        
        UIOffset topLeftOffset = UIOffsetMake(-W,-H);
        UIOffset topRightOffset = UIOffsetMake(W,-H);
        UIOffset bottomLeftOffset = UIOffsetMake(-W,H);
        UIOffset bottomRightOffset = UIOffsetMake(W,H);
        
        CGRect usableSpace = [[UIScreen mainScreen] bounds];
        CGFloat scrnH = usableSpace.size.height;
        CGFloat scrnW = usableSpace.size.width;
        
        CGPoint center = CGPointMake(scrnW/2,scrnH/2);
        
        CGPoint bottomAnchorPoint = CGPointMake(center.x, scrnH);
        //CGPoint bottomAnchorPoint = CGPointMake(center.x,center.y+H);
        
        self.currentAnchor = center;
        NSLog(@"Current Anchor: %@",NSStringFromCGPoint(self.currentAnchor));
        
        
    
        UIAttachmentBehavior *attatchBehavior;
        
        
        attatchBehavior = [[UIAttachmentBehavior alloc]initWithItem:item offsetFromCenter:topLeftOffset attachedToAnchor: self.currentAnchor];
        [attatchBehavior setLength:LENGTH];
        [attatchBehavior setFrequency:FREQUENCY];
        [attatchBehavior setDamping:DAMPING];
        [self addChildBehavior:attatchBehavior];
        
        attatchBehavior = [[UIAttachmentBehavior alloc]initWithItem:item offsetFromCenter:topRightOffset attachedToAnchor: self.currentAnchor];
        [attatchBehavior setLength:LENGTH];
        [attatchBehavior setFrequency:FREQUENCY];
        [attatchBehavior setDamping:DAMPING];
        [self addChildBehavior:attatchBehavior];
        
        attatchBehavior = [[UIAttachmentBehavior alloc]initWithItem:item offsetFromCenter:bottomLeftOffset attachedToAnchor: bottomAnchorPoint];
        [attatchBehavior setLength:H*2];
        [attatchBehavior setFrequency:FREQUENCY];
        [attatchBehavior setDamping:DAMPING];
        [self addChildBehavior:attatchBehavior];
         
        attatchBehavior = [[UIAttachmentBehavior alloc]initWithItem:item offsetFromCenter:bottomRightOffset attachedToAnchor: bottomAnchorPoint];
        [attatchBehavior setLength:H*2];
        [attatchBehavior setFrequency:FREQUENCY];
        [attatchBehavior setDamping:DAMPING];
        [self addChildBehavior:attatchBehavior];
        
        /*
        attatchBehavior = [[UIAttachmentBehavior alloc]initWithItem:item attachedToAnchor:self.currentAnchor];
        [attatchBehavior setLength:LENGTH];
        [attatchBehavior setFrequency:FREQUENCY];
        [attatchBehavior setDamping:DAMPING];
        [self addChildBehavior:attatchBehavior];
        */
        
    }
    return self;
}



-(void)updateAnchorLocation:(CGPoint)p {
    
    NSLog(@"I Got Updated Here: %@",NSStringFromCGPoint(p));

    UIAttachmentBehavior *attatchBehavior;
    
    for (int i=0; i<[self childBehaviors].count; i++) {
        //
        attatchBehavior = [[self childBehaviors] objectAtIndex:i];
        attatchBehavior.anchorPoint = p;
    }
    
//    attatchBehavior = [[self childBehaviors] objectAtIndex:0];
//    attatchBehavior.anchorPoint = p;
//    attatchBehavior = [[self childBehaviors] objectAtIndex:1];
//    attatchBehavior.anchorPoint = p;
}


@end
