//
//  JMWheelLayout.m
//  CV PlayGround
//
//  Created by Justin Madewell on 5/17/14.
//  Copyright (c) 2014 Justin Madewell. All rights reserved.
//

#import "JMWheelLayout.h"
#import "JMCollectionViewLayoutAttributes.h"


@implementation JMWheelLayout

#define ITEM_SIZE 200.0
#define ACTIVE_DISTANCE 1500//280 768
#define TRANSLATE_DISTANCE 100
#define ZOOM_FACTOR 0.2f
#define FLOW_OFFSET 40
#define INACTIVE_GREY_VALUE 0.6f

#define RotateDegree -60.0f

#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)

-(id)init {
    
    if (!(self = [super init])) return nil;
    
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    //[self setSizingValues];
    
    
    return self;

}





- (void)prepareLayout {
    [super prepareLayout];
    
    self.insertIndexPaths = [NSMutableSet set];
    self.deleteIndexPaths = [NSMutableSet set];

    CGSize size = self.collectionView.bounds.size;
    
    self.center = CGPointMake(size.width / 2.0, size.height / 2.0);
    self.cellCount = [[self collectionView] numberOfItemsInSection:0];
    
    
    [self setSizingValues];

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
    
    [self applyLayoutAttributes:attributes forVisibleRect:visibleRect];
    
    return attributes;
}

+(Class)layoutAttributesClass
{
    return [JMCollectionViewLayoutAttributes class];
}


-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
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

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    // if decelerating, let scrollViewDidEndDecelerating: handle it
    if (decelerate == NO) {
        [self removeNaughtyLingeringCells];
       
        
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self removeNaughtyLingeringCells];
    
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




//-(CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
//{
//    CGFloat offsetAdjustment = MAXFLOAT;
//    CGFloat horizontalCenter = proposedContentOffset.x + (CGRectGetWidth(self.collectionView.bounds) / 2.0);
//    
//    CGRect targetRect = CGRectMake(proposedContentOffset.x, 0.0, self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
//    NSArray *array = [super layoutAttributesForElementsInRect:targetRect];
//    
//    for (UICollectionViewLayoutAttributes *layoutAttributes in array) {
//        CGFloat itemHorizontalCenter = layoutAttributes.center.x;
//        if (ABS(itemHorizontalCenter - horizontalCenter) < ABS(offsetAdjustment)) {
//            offsetAdjustment = itemHorizontalCenter - horizontalCenter;
//        }
//    }
//    
//    return CGPointMake(proposedContentOffset.x + offsetAdjustment, proposedContentOffset.y);
//}


-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    
    return YES;
}

-(void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)attributes
              forVisibleRect:(CGRect)visibleRect
{
    attributes.zIndex=attributes.indexPath.row;
    // Applies the cover flow effect to the given layout attributes.
    CGPoint centerInCollectionView = attributes.center;
    CGPoint centerInMainView = [self.collectionView.superview convertPoint:centerInCollectionView fromView:self.collectionView];
    CGFloat positionPoint = [self parallaxPositionForCell:attributes];
    CGPoint rotationPoint = CGPointMake(self.collectionView.frame.size.width/2, self.collectionView.frame.size.height);
    CGFloat rotate = fabsf(positionPoint)  * 45;

    // We want to skip supplementary views.
    if (attributes.representedElementKind) return;
    
    // Calculate the distance from the center of the visible rect to the
    // center of the attributes. Then normalize it so we can compare them
    // all. This way, all items further away than the active get the same
    // transform.
    
    CGFloat distanceFromVisibleRectToItem =
    CGRectGetMidX(visibleRect) - attributes.center.x;
    
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
        transform = CATransform3DTranslate(transform, centerInMainView.x - rotationPoint.x, centerInMainView.y-rotationPoint.y-30.0f, 0.0);
    }
    
    attributes.transform3D=transform;
    attributes.zIndex=attributes.indexPath.row;
}

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

-(void)setSizingValues {
    
    // Set up our basic properties
    UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
    // NSLog(@"DeviceOrentation: %ld",deviceOrientation);

    // Item Size Math
    CGFloat screenHeight = CGRectGetHeight([[UIScreen mainScreen] bounds]); //568 //iPad 1024
    CGFloat screenWidth = CGRectGetWidth([[UIScreen mainScreen] bounds]); //320 //iPad 768
    // Base Values
    CGFloat baseOffset = screenWidth/100;
    CGFloat baseSize = (screenWidth/baseOffset);
    // Relative Base Item Size
    CGSize baseItemSize = CGSizeMake((screenWidth/baseOffset),(screenHeight/baseOffset));
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        // iPad
        CGFloat iPadvScale = (baseSize * baseOffset); //300
        CGFloat iPadhScale = (baseSize * (baseOffset/2));
        CGSize iPadVItemSize = CGSizeMake(baseItemSize.width+(iPadvScale/4),baseItemSize.height+(iPadvScale/2));
        CGSize iPadHItemSize = CGSizeMake(baseItemSize.width+(iPadhScale/2),baseItemSize.height+(iPadhScale));

        if (deviceOrientation == 0) {
            // UIDeviceOrientationUnknown
            self.itemSize = iPadVItemSize;
            self.minimumLineSpacing = -self.itemSize.width/4;
            self.minimumInteritemSpacing = screenHeight/2;
            self.sectionInset = UIEdgeInsetsMake(self.itemSize.width, self.itemSize.width/2, 0, self.itemSize.width/2);
        }
        if (deviceOrientation == 1) {
            // UIDeviceOrientationPortrait
            self.itemSize = iPadVItemSize;
            self.minimumLineSpacing = -self.itemSize.width/4;
            self.minimumInteritemSpacing = screenHeight/2;
            self.sectionInset = UIEdgeInsetsMake(self.itemSize.width, self.itemSize.width, 0, self.itemSize.width);
        }
        if (deviceOrientation == 2) {
            // UIDeviceOrientationPortraitUpsideDown
            self.itemSize = iPadVItemSize;
            self.minimumLineSpacing = -self.itemSize.width/4;
            self.minimumInteritemSpacing = screenHeight/2;
            self.sectionInset = UIEdgeInsetsMake(self.itemSize.width, self.itemSize.width, 0, self.itemSize.width);
        }
        if (deviceOrientation == 3) {
            // UIDeviceOrientationLandscapeLeft
            self.itemSize = iPadHItemSize;
            self.minimumLineSpacing = -self.itemSize.width/4;
            self.minimumInteritemSpacing = screenWidth/2;
            CGFloat pad = (self.itemSize.width)+(self.itemSize.width/4);
            self.sectionInset = UIEdgeInsetsMake(self.itemSize.width/2, pad, 0, pad);
        }
        if (deviceOrientation == 4) {
            // UIDeviceOrientationLandscapeRight
            self.itemSize = iPadHItemSize;
            self.minimumLineSpacing = -self.itemSize.width/4;
            self.minimumInteritemSpacing = screenWidth/2;
            CGFloat pad = (self.itemSize.width)+(self.itemSize.width/4);
            self.sectionInset = UIEdgeInsetsMake(self.itemSize.width/2, pad, 0, pad);
        }
        
         /*
         
         Not Using Yet
         
         if (deviceOrientation == 5) {
         // UIDeviceOrientationFaceUp
          self.itemSize = iPadVItemSize;
          self.minimumLineSpacing = -self.itemSize.width/3;
          self.minimumInteritemSpacing = screenHeight/2;
          self.sectionInset = UIEdgeInsetsMake(self.itemSize.width, self.itemSize.width/2, 0, self.itemSize.width/2);
         }
         if (deviceOrientation == 6) {
         // UIDeviceOrientationFaceDown
          self.itemSize = iPadVItemSize;
          self.minimumLineSpacing = -self.itemSize.width/3;
          self.minimumInteritemSpacing = screenHeight/2;
          self.sectionInset = UIEdgeInsetsMake(self.itemSize.width, self.itemSize.width/2, 0, self.itemSize.width/2);
         */
        
    }
    else
    {
        // iPhone
        CGFloat iPhoneVScale = (baseSize/(baseOffset/2)); //62.50
        CGFloat iPhoneHScale = (baseSize/baseOffset); //31.25
        CGSize iPhoneVItemSize = CGSizeMake(baseItemSize.width+iPhoneVScale,baseItemSize.height+iPhoneVScale);
        CGSize iPhoneHItemSize = CGSizeMake(baseItemSize.width+iPhoneHScale,baseItemSize.height+iPhoneHScale);
        
        if (deviceOrientation == 0) {
            // UIDeviceOrientationUnknown
            self.itemSize = iPhoneVItemSize;
            self.minimumLineSpacing = -self.itemSize.width/4;
            self.minimumInteritemSpacing = screenHeight/2;
            self.sectionInset = UIEdgeInsetsMake(self.itemSize.width, self.itemSize.width/2, 0, self.itemSize.width/2);
            
        }
        if (deviceOrientation == 1) {
            // iPhone Portrait
            // UIDeviceOrientationPortrait
            self.itemSize = iPhoneVItemSize;
            self.minimumLineSpacing = -self.itemSize.width/4;
            self.minimumInteritemSpacing = screenHeight/2;
            self.sectionInset = UIEdgeInsetsMake(self.itemSize.width, self.itemSize.width/2, 0, self.itemSize.width/2);
        }
        if (deviceOrientation == 2) {
            // iPhone Portrait
            // UIDeviceOrientationPortraitUpsideDown
            self.itemSize = iPhoneVItemSize;
            self.minimumLineSpacing = -self.itemSize.width/4;
            self.minimumInteritemSpacing = screenHeight/2;
            self.sectionInset = UIEdgeInsetsMake(self.itemSize.width, self.itemSize.width/2, 0, self.itemSize.width/2);
        }
        if (deviceOrientation == 3) {
            // LandScape / Horizontal
            self.itemSize = iPhoneHItemSize; //Item Size: {131.25, 208.75}
            self.minimumLineSpacing = -self.itemSize.width/4;
            self.minimumInteritemSpacing = screenWidth/2;
            CGFloat pad = (self.itemSize.width)+(self.itemSize.width/2);
            self.sectionInset = UIEdgeInsetsMake(self.itemSize.width/2, pad, 0, pad);
        }
        if (deviceOrientation == 4) {
            // LandScape / Horizontal
            self.itemSize = iPhoneHItemSize; //Item Size: {131.25, 208.75}
            self.minimumLineSpacing = -self.itemSize.width/4;
            self.minimumInteritemSpacing = screenWidth/2;
            CGFloat pad = (self.itemSize.width)+(self.itemSize.width/2);
            self.sectionInset = UIEdgeInsetsMake(self.itemSize.width/2, pad, 0, pad);
        }
        
         /*
         Not Using Yet
        
        if (deviceOrientation == 5) {
            // UIDeviceOrientationFaceUp
         self.itemSize = iPhoneVItemSize;
         self.minimumLineSpacing = -self.itemSize.width/3;
         self.minimumInteritemSpacing = screenHeight/2;
         self.sectionInset = UIEdgeInsetsMake(self.itemSize.width, self.itemSize.width/2, 0, self.itemSize.width/2);
        }
        if (deviceOrientation == 6) {
            // UIDeviceOrientationFaceDown
         self.itemSize = iPhoneVItemSize;
         self.minimumLineSpacing = -self.itemSize.width/3;
         self.minimumInteritemSpacing = screenHeight/2;
         self.sectionInset = UIEdgeInsetsMake(self.itemSize.width, self.itemSize.width/2, 0, self.itemSize.width/2);
        }
         
        */
        
    }
    
    self.activeInteger = ((screenHeight+screenWidth)*2);
   // NSLog(@"Active INT: %li",(long)self.activeInteger);
    
}




@end
