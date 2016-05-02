//
//  JMHorizontalFlow.m
//  CV PlayGround
//
//  Created by Justin Madewell on 5/14/14.
//  Copyright (c) 2014 Justin Madewell. All rights reserved.
//

#import "JMHorizontalFlow.h"

@implementation JMHorizontalFlow

-(id)init {
    if (!(self = [super init])) return nil;
    
    //self.minimumInteritemSpacing = 10;
    
    return self;
}


- (void)prepareLayout {
    [super prepareLayout];
    
    //Set Header & Footer Sizes
    self.headerReferenceSize = CGSizeMake(100, 100);
    self.footerReferenceSize = CGSizeMake(50, 50);
    self.itemSize = CGSizeMake(100, 100);
    
    //self.minimumLineSpacing = 200;
    
     self.sectionInset = UIEdgeInsetsMake(200, 10, 200, 10);
    
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
}

-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    
    
    return [super layoutAttributesForElementsInRect:rect];
}


-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    
    return NO;
}



@end
