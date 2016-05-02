//
//  JMSimpleSpringyLayout.m
//  CV PlayGround
//
//  Created by Justin Madewell on 5/26/14.
//  Copyright (c) 2014 Justin Madewell. All rights reserved.
//

#import "JMSimpleSpringyLayout.h"
#import "RectangleAttatchmentBehavior.h"
#import "BottomAnchorBehavior.h"

#define LIFTUP 30
#define ANGLE 45
#define LIFT 65
#define ITEM_SIZE 260
#define SCROLL_RESISTANCE 1500.0f

@interface JMSimpleSpringyLayout ()


@property (nonatomic, assign) CGFloat itemDistance;

@property (nonatomic, strong) RectangleAttatchmentBehavior *rectangleAttatchmentBehavior;
@property (nonatomic, strong) BottomAnchorBehavior *bottomAnchorBehavior;


@property (nonatomic, strong) UIAttachmentBehavior *stick;
@property (nonatomic, strong) UIAttachmentBehavior *anchor;


@property (nonatomic, strong) UIDynamicAnimator *dynamicAnimator;

@property (nonatomic, strong) NSMutableArray *anchorAttachtmentArray;


@property (nonatomic, strong) UIDynamicItemBehavior *dynamicItemBehavior;
@property (nonatomic, strong) UIDynamicBehavior *dynamicBehavior;
@property (nonatomic, strong) UISnapBehavior *snapBehavior;
@property (nonatomic, strong) UIAttachmentBehavior *anchorAttatchmentBehavior;
@property (nonatomic, strong) UIAttachmentBehavior *bottomRightAttatchmentBehavior;
@property (nonatomic, strong) UIAttachmentBehavior *bottomLeftAttatchmentBehavior;
@property (nonatomic, strong) UIAttachmentBehavior *topLeftAttatchmentBehavior;
@property (nonatomic, strong) UIAttachmentBehavior *topRightAttatchmentBehavior;
@property (nonatomic, strong) UIAttachmentBehavior *cellToCellAttatchmentBehavior;


@end

@implementation JMSimpleSpringyLayout






- (id)init
{
    if (!(self = [super init])) return nil;
    
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    [self setYourSizes];

    _dynamicAnimator = [[UIDynamicAnimator alloc] initWithCollectionViewLayout:self];

    return self;
}


-(void)prepareLayout
{
    [super prepareLayout];
    
    CGSize contentSize = self.collectionView.contentSize;
    CGRect superRect = CGRectMake(0, 0, contentSize.width, contentSize.height);
    
    NSArray *array = [super layoutAttributesForElementsInRect:superRect];
    
    if (_dynamicAnimator.behaviors.count == 0)
    {
        for (int i=0; i<array.count; i++)
        {
            UICollectionViewLayoutAttributes *attributes = [array objectAtIndex:i];
            CGPoint center = attributes.center;
            NSLog(@"center point for %i :%@",i,NSStringFromCGPoint(center));
            
           
            
            _bottomAnchorBehavior = [[BottomAnchorBehavior alloc]initWithItem:attributes point:attributes.center];
            
            
            [_dynamicAnimator addBehavior:_bottomAnchorBehavior];
           // NSLog(@"Attatchment Set for Cell: %li",(long)attributes.indexPath.row);
            
            
        }

    }
    
}

-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return [_dynamicAnimator itemsInRect:rect];
    
}

-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [_dynamicAnimator layoutAttributesForCellAtIndexPath:indexPath];
    
}

-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    UIScrollView *scrollView = self.collectionView;
    
    CGFloat offsetX = scrollView.contentOffset.x;
    //NSLog(@"X OFFSET: %f",offsetX);
    CGFloat delta = newBounds.origin.x - scrollView.bounds.origin.x;
    //NSLog(@"Delta: %f",delta);
    
    
    CGPoint touchLocation = [self.collectionView.panGestureRecognizer
                             locationInView:self.collectionView];
    
    
    NSArray *visibleItemsIndexPaths = [self.collectionView indexPathsForVisibleItems];
    
    NSIndexPath *currentVisiblePath = [visibleItemsIndexPaths lastObject];
    
    for (BottomAnchorBehavior *bottomAnchorBehavior in _dynamicAnimator.behaviors)
    {
        CGPoint currentAnchorLocation = bottomAnchorBehavior.currentAnchor;
        // NSLog(@"currentAnchorLocation : %@",NSStringFromCGPoint(currentAnchorLocation));
        
        CGPoint newAnchorLoaction = CGPointMake(currentAnchorLocation.x-(offsetX), currentAnchorLocation.y);
        // NSLog(@"newAnchorLoaction : %@",NSStringFromCGPoint(newAnchorLoaction));
        
        UICollectionViewLayoutAttributes *cell = [[[[bottomAnchorBehavior childBehaviors]firstObject]items]firstObject];
        NSIndexPath *cellPath = cell.indexPath;
        CGPoint center = cell.center;
        
        CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
        CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
        CGFloat difference = screenHeight - center.y;
        //NSLog(@"difference: %f",difference);
        
        CGPoint centerAnchor = CGPointMake(screenWidth/2, screenHeight);
        //
        if ([visibleItemsIndexPaths containsObject:cellPath]) {
            //Set New Anchor Point
            [bottomAnchorBehavior updateAnchorLocation:centerAnchor];
        }
        //
        CGPoint newCenter = CGPointMake(center.x-(offsetX/4), center.y);
        cell.center = newCenter;
        [_dynamicAnimator updateItemUsingCurrentState:cell];
    }
    
    
    

    
    
    //
    
    //
    //
//    [_dynamicAnimator.behaviors enumerateObjectsUsingBlock:^(BottomAnchorBehavior *bottomAnchorBehavior, NSUInteger idx, BOOL *stop)
//     {
//         
//         NSArray *animatedBehaviors =  _dynamicAnimator.behaviors;
//         UIAttachmentBehavior *centerAnchorBehavior = [animatedBehaviors firstObject];
//         
//         
//         
//        
//         
//         CGPoint currentCellCenter =  anchorBehavior.anchorPoint;
//         UICollectionViewLayoutAttributes *cell = [[centerAnchorBehavior items] firstObject];
//         
//         NSLog(@"Cell %li Center Point: %@",(long)cell.indexPath.row,NSStringFromCGPoint(currentCellCenter));
//         
//         CGFloat distanceFromTouch = fabsf(touchLocation.x - currentCellCenter.x);
//         CGFloat scrollResistance = distanceFromTouch /
//         (SCROLL_RESISTANCE/4);
//         
//         CGPoint newCenter = cell.center;
//         if (delta < 0) {
//             newCenter.x += MAX(delta, delta*scrollResistance);
//         }
//         else {
//             newCenter.x += MIN(delta, delta*scrollResistance);
//         }
//         cell.center = newCenter;
//         
//         //[anchorBehavior updateAttatchmentLocation:newCenter];
//         
//         [_dynamicAnimator updateItemUsingCurrentState:cell];
//     }];
    //
    //

    
    return NO;
}

#pragma mark - Touches

#pragma mark - Custom Layout Attributes

-(void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)attributes
              forVisibleRect:(CGRect)visibleRect
{
    NSArray *items = [super layoutAttributesForElementsInRect:visibleRect];
    
    // Get Anchor Points for Attatchments
    CGPoint screenAnchorPoint = CGPointMake(self.collectionView.frame.size.width/2, self.collectionView.frame.size.height);
    //NSLog(@"Anchor Point: %@",NSStringFromCGPoint(screenAnchorPoint));
    CGPoint screenCenterPoint = CGPointMake(self.collectionView.frame.size.width/2, self.collectionView.frame.size.height/2);
    //NSLog(@"Screen Center Point: %@",NSStringFromCGPoint(screenCenterPoint));
    
    [items enumerateObjectsUsingBlock:^(id<UIDynamicItem> obj, NSUInteger idx, BOOL *stop)
     {
         CGRect objectRect =  [obj bounds];
         // Create Offsets for Attatchment Points;
         UIOffset bottomLeftOffset =  UIOffsetMake(-objectRect.size.width/2, objectRect.size.height/2);
         
         UIOffset bottomRightOffset = UIOffsetMake(objectRect.size.width/2, objectRect.size.height/2);
        
         self.bottomLeftAttatchmentBehavior = [[UIAttachmentBehavior alloc]initWithItem:obj offsetFromCenter:bottomLeftOffset attachedToAnchor:screenAnchorPoint];
         self.bottomLeftAttatchmentBehavior.length = 200.0f;
         self.bottomLeftAttatchmentBehavior.damping = 0.5f;
         self.bottomLeftAttatchmentBehavior.frequency = 1.0f;
         
         self.bottomRightAttatchmentBehavior = [[UIAttachmentBehavior alloc]initWithItem:obj offsetFromCenter:bottomRightOffset attachedToAnchor:screenAnchorPoint];
         self.bottomRightAttatchmentBehavior.length = 200.0f;
         self.bottomRightAttatchmentBehavior.damping = 0.5f;
         self.bottomRightAttatchmentBehavior.frequency = 1.0f;
         
         self.anchorAttatchmentBehavior = [[UIAttachmentBehavior alloc]initWithItem:obj attachedToAnchor:screenCenterPoint];
         
         self.anchorAttatchmentBehavior.length = 0.0f;
         self.anchorAttatchmentBehavior.damping = 0.5; //0.8
         self.anchorAttatchmentBehavior.frequency = 1.0f; //1.0
         
         [self.dynamicAnimator removeAllBehaviors];
         
         [self.dynamicAnimator addBehavior:self.anchorAttatchmentBehavior];
         [self.dynamicAnimator addBehavior:self.bottomRightAttatchmentBehavior];
         [self.dynamicAnimator addBehavior:self.bottomLeftAttatchmentBehavior];
         
         
     }];
    

    //
}


-(void)setYourSizes {
    
    CGFloat screenHeight = CGRectGetHeight([[UIScreen mainScreen] bounds]);
    CGFloat screenWidth = CGRectGetWidth([[UIScreen mainScreen] bounds]);
    
    // 4:3 Ratio
    CGFloat itemChunk = ITEM_SIZE/4; //65
    CGFloat itemW = itemChunk*3; //195
    CGFloat itemH = itemChunk*4; //260
    
    self.itemDistance = screenWidth - itemW;
    
    self.itemSize = CGSizeMake(itemW, itemH); //{195, 260}
    self.minimumLineSpacing = self.itemDistance;
    self.minimumInteritemSpacing = screenHeight/2; // Middle
    // Insets
    CGFloat top = 0;//self.itemSize.width/2;//0.0f;
    CGFloat left =self.itemDistance/2;
    CGFloat right =self.itemDistance/2;
    CGFloat bottom = 0.0f;
    UIEdgeInsets myInset = UIEdgeInsetsMake(top, left, bottom, right);
    //
    self.sectionInset = myInset;
    
    NSLog(@"Sizes Set");
}


#pragma mark - Animation

-(void)setupAnimatorAndBehaviors
{
    
    CGSize contentSize = self.collectionView.contentSize;
    // [super collectionViewContentSize];
   //CGSize contentSize = [super collectionViewContentSize];
    
    CGRect superRect = CGRectMake(0, 0, contentSize.width, contentSize.height);
    
    NSArray *array = [super layoutAttributesForElementsInRect:superRect];
    
    _dynamicAnimator = [[UIDynamicAnimator alloc] initWithCollectionViewLayout:self];
    
    for (UICollectionViewLayoutAttributes *attributes in array)
    {
        _anchorAttatchmentBehavior = [[UIAttachmentBehavior alloc]initWithItem:attributes attachedToAnchor:attributes.center];
        _anchorAttatchmentBehavior.length = 0.0f;
        _anchorAttatchmentBehavior.damping = 0.8; //0.8
        _anchorAttatchmentBehavior.frequency = 1.0f; //1.0
        
        [_dynamicAnimator addBehavior:_anchorAttatchmentBehavior];
    }
    
    NSLog(@"Animation Setup COMPLETE");
}






@end
