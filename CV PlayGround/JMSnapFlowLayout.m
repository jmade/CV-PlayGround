//
//  JMSnapFlowLayout.m
//  CV PlayGround
//
//  Created by Justin Madewell on 5/26/14.
//  Copyright (c) 2014 Justin Madewell. All rights reserved.
//

#import "JMSnapFlowLayout.h"

@interface JMSnapFlowLayout ()

@property (nonatomic, assign) CGFloat itemDistance;

@end

@implementation JMSnapFlowLayout

#define LIFTUP 30
#define ANGLE 45
#define LIFT 65
#define ITEM_SIZE 260

#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)




-(id)init {
    
    if (!(self = [super init])) return nil;
    
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    [self setYourSizes];
    
    
    return self;
    
}


- (void)prepareLayout {
    [super prepareLayout];
    
    self.insertIndexPaths = [NSMutableSet set];
    self.deleteIndexPaths = [NSMutableSet set];
    
    CGSize size = self.collectionView.bounds.size;
    
    self.center = CGPointMake(size.width / 2.0, size.height / 2.0);
    self.cellCount = [[self collectionView] numberOfItemsInSection:0];

    [self setYourSizes];
    
}




#pragma mark - Layout Methods

-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray* array = [super layoutAttributesForElementsInRect:rect];
    
    // We're going to calculate the rect of the collection view visisble to the user
    CGRect visibleRect = CGRectMake(
                                    self.collectionView.contentOffset.x,
                                    self.collectionView.contentOffset.y,
                                    CGRectGetWidth(self.collectionView.bounds),
                                    CGRectGetHeight(self.collectionView.bounds));
    
    for (UICollectionViewLayoutAttributes* attributes in array)
    {
        // We're going to calculate the rect of the collection
        // view visible to the user.
        // That way, we can avoid laying out cells that are not visible.
        if (CGRectIntersectsRect(attributes.frame, rect))
        {
           // [self applyLayoutAttributes:attributes forVisibleRect:visibleRect];
            [self applyLayoutAttributes2:attributes forVisibleRect:visibleRect];
        }
    }
    
    return array;
    
    
}

-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    
    return YES;
}

- (UICollectionViewLayoutAttributes
   *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attributes = [super layoutAttributesForItemAtIndexPath:indexPath];
    
    // We're going to calculate the rect of the collection view visible
    // to the user.
    CGRect visibleRect = CGRectMake(
                                    self.collectionView.contentOffset.x,
                                    self.collectionView.contentOffset.y,
                                    CGRectGetWidth(self.collectionView.bounds),
                                    CGRectGetHeight(self.collectionView.bounds));
    
   // [self applyLayoutAttributes:attributes forVisibleRect:visibleRect];
    attributes.alpha = 0.2;
    return attributes;
}



- (UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath
{

    // Must call super
    UICollectionViewLayoutAttributes *attributes = [super initialLayoutAttributesForAppearingItemAtIndexPath:itemIndexPath];
    attributes = [self layoutAttributesForItemAtIndexPath:itemIndexPath];
    attributes.alpha = 0.0;
    
    //    if ([self.insertIndexPaths containsObject:itemIndexPath])
    //    {
    //        // only change attributes on inserted cells
    //        if (!attributes)
    //            attributes = [self layoutAttributesForItemAtIndexPath:itemIndexPath];
    //
    //        // Configure attributes ...
    //        attributes.alpha = 0.0;
    //        attributes.center = CGPointMake(_center.x, _center.y);
    //    }
    
    return attributes;
}

- (UICollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingItemAtIndexPath:(NSIndexPath *)itemIndexPath
{
    // So far, calling super hasn't been strictly necessary here, but leaving it in
    // for good measure
    UICollectionViewLayoutAttributes *attributes = [super finalLayoutAttributesForDisappearingItemAtIndexPath:itemIndexPath];
    attributes = [self layoutAttributesForItemAtIndexPath:itemIndexPath];
    attributes.alpha = 0.0;
    
    //    if ([self.deleteIndexPaths containsObject:itemIndexPath])
    //    {
    //        // only change attributes on deleted cells
    //        if (!attributes)
    //            attributes = [self layoutAttributesForItemAtIndexPath:itemIndexPath];
    //
    //        // Configure attributes ...
    //        attributes.alpha = 0.0;
    //        attributes.center = CGPointMake(_center.x, _center.y);
    //        attributes.transform3D = CATransform3DMakeScale(0.1, 0.1, 1.0);
    //    }
    
    return attributes;
}

#pragma mark - ScrollView

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    // if decelerating, let scrollViewDidEndDecelerating: handle it
    if (decelerate == NO) {
        //[self removeNaughtyLingeringCells];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    //[self removeNaughtyLingeringCells];
    
}


/*

// NOT USING -- MAKES CELLS AUTO SNAP TO CENTER

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

*/



 
#pragma mark - New Attributes Implementation

-(void)applyLayoutAttributes2:(UICollectionViewLayoutAttributes *)attributes
               forVisibleRect:(CGRect)visibleRect
{
    
    
    CGFloat base = visibleRect.origin.x/self.collectionView.bounds.size.width;
    CGFloat fixedBase = base - attributes.indexPath.row;
    CGFloat rotate = fixedBase * ANGLE;
    
    CGFloat yPoint = ABS(fixedBase) * -(self.itemDistance);
    attributes.center = CGPointMake(attributes.center.x,(attributes.center.y-yPoint));
    CATransform3D transform = CATransform3DIdentity;
    
    transform =  CATransform3DRotate(transform, DEGREES_TO_RADIANS(-rotate), 0.0, 0.0, 1.0);
    
    

    attributes.transform3D = transform;
    
}

#pragma mark - Custom Layout Attributes

-(void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)attributes
              forVisibleRect:(CGRect)visibleRect
{
    attributes.zIndex=attributes.indexPath.row;
    // Applies the cover flow effect to the given layout attributes.
    CGPoint centerInCollectionView = attributes.center;
    CGPoint centerInMainView = [self.collectionView.superview convertPoint:centerInCollectionView fromView:self.collectionView];
    CGFloat positionPoint = [self parallaxPositionForCell:attributes];
    CGPoint rotationPoint = CGPointMake(self.collectionView.frame.size.width/2, self.collectionView.frame.size.height);
    CGFloat rotate = fabsf(positionPoint)  * 180;
    
    // We want to skip supplementary views.
    if (attributes.representedElementKind) return;
    
    // Calculate the distance from the center of the visible rect to the
    // center of the attributes. Then normalize it so we can compare them
    // all. This way, all items further away than the active get the same
    // transform.
    
    CGFloat distanceFromVisibleRectToItem =
    CGRectGetMidX(visibleRect) - attributes.center.x;
    
    self.activeInteger = 1000;
    
    CGFloat normalizedDistance =
    distanceFromVisibleRectToItem / self.activeInteger;
    
    // Handy for use in making a number negative selectively
    BOOL isLeft = distanceFromVisibleRectToItem > 0;
    
    // Default values
    CATransform3D transform = CATransform3DIdentity;
    
    if (fabsf(distanceFromVisibleRectToItem) < self.activeInteger)
    {
        
        transform = CATransform3DTranslate(transform, rotationPoint.x - centerInMainView.x, rotationPoint.y - centerInMainView.y, 0.0);
        
        transform = CATransform3DRotate(transform,
                                        (isLeft? 1 : -1) * fabsf(normalizedDistance) *
                                        DEGREES_TO_RADIANS(-rotate)
                                        ,
                                        0,
                                        0,
                                        1);
        
        // -30.0f to lift the cards up a bit
        transform = CATransform3DTranslate(transform, centerInMainView.x - rotationPoint.x, centerInMainView.y-rotationPoint.y-LIFTUP, 0.0);
    }
    
    attributes.transform3D=transform;
    attributes.zIndex=attributes.indexPath.row;
}



#pragma mark - Custom Helper Methods


- (void) removeNaughtyLingeringCells {
    
    // 1. Find the visible cells
    NSArray *visibleCells = self.collectionView.visibleCells;
    //NSLog(@"We have %i visible cells", visibleCells.count);
    
    // 2. Find the visible rect of the collection view on screen now
    CGRect visibleRect;
    visibleRect.origin = self.collectionView.contentOffset;
    visibleRect.size = self.collectionView.bounds.size;
    NSLog(@"Rect %@", NSStringFromCGRect(visibleRect));
    
    
    // 3. Find the subviews that shouldn't be there and remove them
    //NSLog(@"We have %i subviews", self.collectionView.subviews.count);
    for (UIView *aView in [self.collectionView subviews]) {
        if ([aView isKindOfClass:UICollectionViewCell.class]) {
            CGPoint origin = aView.frame.origin;
            if(CGRectContainsPoint(visibleRect, origin)) {
                if (![visibleCells containsObject:aView]) {
                    [aView removeFromSuperview];
                }
            }
        }
    }
    //NSLog(@"%i views shouldn't be there", viewsShouldntBeThere.count);
    
    // 4. Refresh the collection view display
    [self.collectionView setNeedsDisplay];
}




-(CGPoint)calculateTranslateBy:(CGFloat)horizontalCenter attribs:(UICollectionViewLayoutAttributes *) layoutAttributes{
    
    float translateByY = -layoutAttributes.frame.size.height/2.0f;
    float distanceFromCenter = layoutAttributes.center.x - horizontalCenter;
    float translateByX = 0.0f;
    
    if (distanceFromCenter < 1){
        translateByX = -1 * distanceFromCenter;
    }else{
        translateByX = -1 * distanceFromCenter;
    }
    return CGPointMake(distanceFromCenter, translateByY);
    
}

- (CGFloat)parallaxPositionForCell:(UICollectionViewLayoutAttributes *)cell {
    
    CGRect frame = [cell frame];
    UICollectionViewCell *theCell = [self.collectionView cellForItemAtIndexPath:cell.indexPath];
    
    CGPoint point = [[theCell superview] convertPoint:frame.origin toView:self.collectionView];
    
    const CGFloat minX = CGRectGetMinX([self.collectionView bounds]) - frame.size.width;
    const CGFloat maxX = CGRectGetMaxX([self.collectionView bounds]);
    
    const CGFloat minPos = -1.0f;
    const CGFloat maxPos = 1.0f;
    
    return (maxPos - minPos) / (maxX - minX) * (point.x - minX) + minPos;
}

-(void)setYourSizes {
    
    CGFloat screenHeight = CGRectGetHeight([[UIScreen mainScreen] bounds]);
    CGFloat screenWidth = CGRectGetWidth([[UIScreen mainScreen] bounds]);
    
    
    // 4:3 Ratio
    CGFloat itemChunk = ITEM_SIZE/4; //65
    CGFloat itemW = itemChunk*3; //195
    CGFloat itemH = itemChunk*4; //260
    
    self.itemDistance = screenWidth - itemW;
    CGFloat widthRdr = screenWidth - itemW;
    
    
    
    self.itemSize = CGSizeMake(itemW, itemH); //{195, 260}
    self.minimumLineSpacing = widthRdr;
    self.minimumInteritemSpacing = screenHeight/2; // Middle
    // Insets
    CGFloat top = self.itemSize.width/2;//0.0f;
    CGFloat left =self.itemDistance/2;//0.0f; //self.itemSize.width/2;
    CGFloat right =self.itemDistance/2;// 0.0f; //self.itemSize.width/2;
    CGFloat bottom = 0.0f;
    UIEdgeInsets myInset = UIEdgeInsetsMake(top, left, bottom, right);
    //
    self.sectionInset = myInset;
}





@end
