//
//  JMCollectionViewLayoutAttributes.m
//  CV PlayGround
//
//  Created by Justin Madewell on 5/17/14.
//  Copyright (c) 2014 Justin Madewell. All rights reserved.
//

#import "JMCollectionViewLayoutAttributes.h"

@implementation JMCollectionViewLayoutAttributes


-(id)copyWithZone:(NSZone *)zone
{
    JMCollectionViewLayoutAttributes *attributes = [super copyWithZone:zone];
    attributes.shouldRasterize = self.maskingValue;
    
    return attributes;
}

-(BOOL)isEqual:(JMCollectionViewLayoutAttributes*)other
{
    return  [super isEqual:other] && (self.shouldRasterize == other.shouldRasterize && self.maskingValue == other.maskingValue);
}

@end
