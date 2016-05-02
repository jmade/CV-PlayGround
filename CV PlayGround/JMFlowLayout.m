//
//  JMFlowLayout.m
//  CV PlayGround
//
//  Created by Justin Madewell on 5/14/14.
//  Copyright (c) 2014 Justin Madewell. All rights reserved.
//

#import "JMFlowLayout.h"

#define ITEM_SIZE 200.0
#define ACTIVE_DISTANCE 200
#define ZOOM_FACTOR 0.4

@implementation JMFlowLayout



- (void)prepareLayout {
    [super prepareLayout];
    
    self.insertedRowSet = [NSMutableSet set];
    self.deletedRowSet = [NSMutableSet set];
    
    UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    CGSize size = self.collectionView.bounds.size;
    
    self.center = CGPointMake(size.width / 2.0, size.height / 2/0);
    self.cellCount = [[self collectionView] numberOfItemsInSection:0];
    
    
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        // The device is an iPad running iOS 3.2 or later.
        self.itemSize = CGSizeMake(ITEM_SIZE, ITEM_SIZE);
        if (UIDeviceOrientationIsLandscape(deviceOrientation)) {
            // LandScape
            self.sectionInset = UIEdgeInsetsMake(200, 0.0, 200, 0.0);
        }
        else
        {
            // Portrait
            self.sectionInset = UIEdgeInsetsMake(400, 0.0, 400, 0.0);
            
        }
        
    }
    else
    {
        // The device is an iPhone or iPod touch.
        self.itemSize = CGSizeMake(150, 150);
        if (UIDeviceOrientationIsLandscape(deviceOrientation)) {
            // LandScape
            self.sectionInset = UIEdgeInsetsMake(50, 0.0, 50, 0.0);
        }
        else
        {
            // Portrait
            self.sectionInset = UIEdgeInsetsMake(150, 0.0, 150, 0.0);
            
        }

        
    }
    
    self.minimumLineSpacing = 50.0;

    
}

-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    
//    NSArray *array = [super layoutAttributesForElementsInRect:rect];
//    for (UICollectionViewLayoutAttributes *attrs in array)
//    {
//        //
//    }
//    
//    CGPoint offset = [self.collectionView contentOffset];
//    // NSLog(@"OFFSET: %f",offset.y);
//    CGFloat inset = -48;
//    
//    if (offset.y < inset)
//    {
//        CGFloat deltaY = fabsf(offset.y - inset);
//        //NSLog(@"DELTA: %f",deltaY);
//        
//        for (UICollectionViewLayoutAttributes *attrs in array)
//        {
//            if ([attrs representedElementCategory] == UICollectionElementCategoryCell)
//            {
//                
//            }
//        }
//    }
    
    
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


-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    
    return YES;
}


-(void)prepareForCollectionViewUpdates:(NSArray *)updateItems
{
    [super prepareForCollectionViewUpdates:updateItems];
    
    [updateItems
     enumerateObjectsUsingBlock:^(UICollectionViewUpdateItem *updateItem,
                                  NSUInteger idx, BOOL *stop) {
         if (updateItem.updateAction ==
             UICollectionUpdateActionInsert)
         {
             [self.insertedRowSet
              addObject:@(updateItem.indexPathAfterUpdate.item)];
         }
         else if (updateItem.updateAction ==
                  UICollectionUpdateActionDelete)
         {
             [self.deletedRowSet
              addObject:@(updateItem.indexPathBeforeUpdate.item)];
         }
     }];
}

-(void)finalizeCollectionViewUpdates
{
    
    [super finalizeCollectionViewUpdates];
    
    [self.insertedRowSet removeAllObjects];
    [self.deletedRowSet removeAllObjects];
}
- (UICollectionViewLayoutAttributes *)
initialLayoutAttributesForAppearingItemAtIndexPath:
(NSIndexPath *)itemIndexPath
{
    if ([self.insertedRowSet containsObject:@(itemIndexPath.item)])
    {
        UICollectionViewLayoutAttributes *attributes = [self
                                                        layoutAttributesForItemAtIndexPath:itemIndexPath];
        attributes.alpha = 0.0;
        attributes.center = self.center;
        return attributes;
    }
    
    return nil;
}

- (UICollectionViewLayoutAttributes *)
finalLayoutAttributesForDisappearingItemAtIndexPath:
(NSIndexPath *)itemIndexPath
{
    if ([self.deletedRowSet containsObject:@(itemIndexPath.item)])
    {
        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:itemIndexPath];
        attributes.alpha = 0.0;
        attributes.center = self.center;
        attributes.transform3D = CATransform3DConcat(CATransform3DMakeRotation((2 * M_PI * itemIndexPath.item / (self.cellCount + 1)), 0, 0, 1), CATransform3DMakeScale(0.1, 0.1, 1.0));
        
        return attributes;
    }
    
    return nil;
}


@end
