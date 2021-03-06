//
//  JMCoverFlowLayout.m
//  CV PlayGround
//
//  Created by Justin Madewell on 5/17/14.
//  Copyright (c) 2014 Justin Madewell. All rights reserved.
//

#import "JMCoverFlowLayout.h"
#import "JMCollectionViewLayoutAttributes.h"



#define ACTIVE_DISTANCE 100
#define TRANSLATE_DISTANCE 100
#define ZOOM_FACTOR 0.2f
#define FLOW_OFFSET 40
#define INACTIVE_GREY_VALUE 0.6f



@implementation JMCoverFlowLayout



#pragma mark - Overridden Methods

-(id)init
{
    if (!(self = [super init])) return nil;
    UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
    
    // Set up our basic properties
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        // The device is an iPad running iOS 3.2 or later.
        self.itemSize = CGSizeMake(300, 300);
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
        self.itemSize = CGSizeMake(180, 180);
        if (UIDeviceOrientationIsLandscape(deviceOrientation)) {
            // LandScape
            self.sectionInset = UIEdgeInsetsMake(0, 70, 0, 70);//UIEdgeInsetsMake(50, 0.0, 50, 0.0);
            
        }
        else
        {
            // Portrait
            self.sectionInset = UIEdgeInsetsMake(0, 190, 0, 190); //UIEdgeInsetsMake(150, 0.0, 150, 0.0);
            
            if (CGRectGetHeight([[UIScreen mainScreen] bounds]) > 480) {
                // Running on a 4 Inch Screen
            }
           
            
        }
    }

    
    // Gets items up close to one another
    self.minimumLineSpacing = -60;
    
    // Makes sure we only have 1 row of items in portrait mode
    self.minimumInteritemSpacing = 200;
    
    return self;
        
}

+(Class)layoutAttributesClass
{
    return [JMCollectionViewLayoutAttributes class];
}

-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)oldBounds
{
    // Very important — needed to re-layout the cells when scrolling.
    return YES;
}

-(NSArray*)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray* layoutAttributesArray = [super
                                      layoutAttributesForElementsInRect:rect];
    
    // We're going to calculate the rect of the collection view visisble to the user
    CGRect visibleRect = CGRectMake(
                                    self.collectionView.contentOffset.x,
                                    self.collectionView.contentOffset.y,
                                    CGRectGetWidth(self.collectionView.bounds),
                                    CGRectGetHeight(self.collectionView.bounds));
    
    for (UICollectionViewLayoutAttributes* attributes in layoutAttributesArray)
    {
        // We're going to calculate the rect of the collection
        // view visible to the user.
        // That way, we can avoid laying out cells that are not visible.
        if (CGRectIntersectsRect(attributes.frame, rect))
        {
            [self applyLayoutAttributes:attributes forVisibleRect:visibleRect];
        }
    }
    
    return layoutAttributesArray;
}

- (UICollectionViewLayoutAttributes
   *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attributes = [super
                                                    layoutAttributesForItemAtIndexPath:indexPath];
    
    // We're going to calculate the rect of the collection view visible
    // to the user.
    CGRect visibleRect = CGRectMake(
                                    self.collectionView.contentOffset.x,
                                    self.collectionView.contentOffset.y,
                                    CGRectGetWidth(self.collectionView.bounds),
                                    CGRectGetHeight(self.collectionView.bounds));
    
    [self applyLayoutAttributes:attributes forVisibleRect:visibleRect];
    
    return attributes;
}



-(void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)attributes
              forVisibleRect:(CGRect)visibleRect
{
    // Applies the cover flow effect to the given layout attributes.
    
    // We want to skip supplementary views.
    if (attributes.representedElementKind) return;
    
    // Calculate the distance from the center of the visible rect to the
    // center of the attributes. Then normalize it so we can compare them
    // all. This way, all items further away than the active get the same
    // transform.
    CGFloat distanceFromVisibleRectToItem =
    CGRectGetMidX(visibleRect) - attributes.center.x;
    
    CGFloat normalizedDistance =
    distanceFromVisibleRectToItem / ACTIVE_DISTANCE;
    
    // Handy for use in making a number negative selectively
    BOOL isLeft = distanceFromVisibleRectToItem > 0;
    
    // Default values
    CATransform3D transform = CATransform3DIdentity;
    CGFloat maskAlpha = 0.0f;
    
    if (fabsf(distanceFromVisibleRectToItem) < ACTIVE_DISTANCE)
    {
        // We're close enough to apply the transform in relation to
        // how far away from the center we are.
        
        transform = CATransform3DTranslate(
                                           CATransform3DIdentity,
                                           (isLeft? - FLOW_OFFSET : FLOW_OFFSET)*
                                           ABS(distanceFromVisibleRectToItem/TRANSLATE_DISTANCE),
                                           0,
                                           (1 - fabsf(normalizedDistance)) * 40000 + (isLeft? 200 : 0));
        
        // Set the perspective of the transform.
        transform.m34 = -1/(4.6777f * self.itemSize.width);
        
        // Set the zoom factor.
        CGFloat zoom = 1 + ZOOM_FACTOR*(1 - ABS(normalizedDistance));
        transform = CATransform3DRotate(transform,
                                        (isLeft? 1 : -1) * fabsf(normalizedDistance) *
                                        45 * M_PI / 180,
                                        0,
                                        1,
                                        0);
        transform = CATransform3DScale(transform, zoom, zoom, 1);
        attributes.zIndex = 1;
        
        CGFloat ratioToCenter = (ACTIVE_DISTANCE -
                                 fabsf(distanceFromVisibleRectToItem)) / ACTIVE_DISTANCE;
        // Interpolate between 0.0f and INACTIVE_GREY_VALUE
        maskAlpha = INACTIVE_GREY_VALUE + ratioToCenter *
        (-INACTIVE_GREY_VALUE);
    }
    else
    {
        // We're too far away - just apply a standard
        // perspective transform.
        
        transform.m34 = -1/(4.6777 * self.itemSize.width);
        transform = CATransform3DTranslate(transform,
                                           isLeft? -FLOW_OFFSET : FLOW_OFFSET, 0, 0);
        transform = CATransform3DRotate(transform, (
                                                    isLeft? 1 : -1) * 45 * M_PI / 180, 0, 1, 0);
        attributes.zIndex = 0;
        
        maskAlpha = INACTIVE_GREY_VALUE;
    }
    
    attributes.transform3D = transform;
    
    // Rasterize the cells for smoother edges.
    [(JMCollectionViewLayoutAttributes *)attributes
     setShouldRasterize:YES];
    [(JMCollectionViewLayoutAttributes *)attributes
     setMaskingValue:maskAlpha];
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



/*
-(CGPoint)
targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset
withScrollingVelocity:(CGPoint)velocity
{
    // Returns a point where we want the collection view to stop
    // scrolling at.First, calculate the proposed center of the
    // collection view once the collection view has stopped
    CGFloat offsetAdjustment = MAXFLOAT;
    CGFloat horizontalCenter = proposedContentOffset.x +
    (CGRectGetWidth(self.collectionView.bounds) / 2.0);
    
    // Use the center to find the proposed visible rect.
    CGRect proposedRect = CGRectMake(
                                     proposedContentOffset.x,
                                     0.0,
                                     self.collectionView.bounds.size.width,
                                     self.collectionView.bounds.size.height);
    CGPoint propsedCenterPoint = CGPointMake(proposedRect.size.width/2, proposedRect.size.height/2);
    
    // Get the attributes for the cells in that rect.
    NSArray* array = [self
                      layoutAttributesForElementsInRect:proposedRect];
    
    // This loop will find the closest cell to proposed center
    // of the collection view.
    for (UICollectionViewLayoutAttributes* layoutAttributes in array)
    {
        // We want to skip supplementary views
        if (layoutAttributes.representedElementCategory !=
            UICollectionElementCategoryCell)
            continue;
        
        
        //[self.collectionView cellForItemAtIndexPath:[self.collectionView indexPathForItemAtPoint:propsedCenterPoint]];
        
        [self.collectionView scrollToItemAtIndexPath:[self.collectionView indexPathForItemAtPoint:propsedCenterPoint] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        
        
        // Determine if this layout attribute's cell is closer than
        // the closest we have so far
        CGFloat itemHorizontalCenter = layoutAttributes.center.x;
        if (fabsf(itemHorizontalCenter - horizontalCenter) <
            fabsf(offsetAdjustment))
        {
            offsetAdjustment = itemHorizontalCenter - horizontalCenter;
        }
    }
    
//    //return CGPointMake(proposedContentOffset.x + offsetAdjustment,
//                       proposedContentOffset.y);
    return propsedCenterPoint;
}

*/



@end
