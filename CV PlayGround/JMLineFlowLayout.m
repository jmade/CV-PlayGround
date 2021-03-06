//
//  JMLineFlowLayout.m
//  CV PlayGround
//
//  Created by Justin Madewell on 5/14/14.
//  Copyright (c) 2014 Justin Madewell. All rights reserved.
//

#import "JMLineFlowLayout.h"

#define ITEM_SIZE 200.0

@implementation JMLineFlowLayout

#define ACTIVE_DISTANCE 200
#define ZOOM_FACTOR 0.3

-(id)init {
    self = [super init];
    if (self) {
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            // The device is an iPad running iOS 3.2 or later.
            self.itemSize = CGSizeMake(ITEM_SIZE, ITEM_SIZE);
            self.sectionInset = UIEdgeInsetsMake(200, 0.0, 200, 0.0);
            self.minimumLineSpacing = 50.0;
        }
        else
        {
            // The device is an iPhone or iPod touch.
            self.itemSize = CGSizeMake(100, 100);
            self.sectionInset = UIEdgeInsetsMake(50, 0.0, 50, 0.0);
            self.minimumLineSpacing = 50.0;

        }
            }
    
    return self;
}


-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray *array = [super layoutAttributesForElementsInRect:rect];
    CGRect visibleRect;
    visibleRect.origin = self.collectionView.contentOffset;
    visibleRect.size = self.collectionView.bounds.size;
    
    for (UICollectionViewLayoutAttributes *attributes in array) {
        if (CGRectIntersectsRect(attributes.frame, rect)) {
            CGFloat distance = CGRectGetMidX(visibleRect) - attributes.center.x;
            CGFloat normalizedDistance = distance / ACTIVE_DISTANCE;
            if (ABS(distance) < ACTIVE_DISTANCE) {
                CGFloat zoom = 1 + ZOOM_FACTOR * (1 - ABS(normalizedDistance));
                attributes.transform3D = CATransform3DMakeScale(zoom, zoom, 1.0);
                attributes.zIndex = round(zoom);
            }
        }
    }
    
    return array;
}


-(CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    CGFloat offsetAdjustment = MAXFLOAT;
    CGFloat horizontalCenter = proposedContentOffset.x + (CGRectGetWidth(self.collectionView.bounds) / 2.0);
    
    CGRect targetRect = CGRectMake(proposedContentOffset.x, 0.0, self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
    NSArray *array = [super layoutAttributesForElementsInRect:targetRect];
    
    for (UICollectionViewLayoutAttributes *layoutAttributes in array) {
        CGFloat itemHorizontalCenter = layoutAttributes.center.x;
        if (ABS(itemHorizontalCenter - horizontalCenter) < ABS(offsetAdjustment)) {
            offsetAdjustment = itemHorizontalCenter - horizontalCenter;
        }
    }
    
    return CGPointMake(proposedContentOffset.x + offsetAdjustment, proposedContentOffset.y);
}




-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}












@end
