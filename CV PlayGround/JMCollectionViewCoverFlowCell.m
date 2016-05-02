//
//  JMCollectionViewCoverFlowCell.m
//  CV PlayGround
//
//  Created by Justin Madewell on 5/17/14.
//  Copyright (c) 2014 Justin Madewell. All rights reserved.
//

#import "JMCollectionViewCoverFlowCell.h"
#import "JMCollectionViewLayoutAttributes.h"
//#import "UIImage+Resize.h"

@interface JMCollectionViewCoverFlowCell ()

@property (nonatomic, strong, readwrite) UIImageView *MJImageView;

@end

@implementation JMCollectionViewCoverFlowCell

- (id)initWithFrame:(CGRect)frame
{
    if (!(self = [super initWithFrame:frame])) return nil;
    [self setupImageView];
    
    CALayer *layer = self.layer;
    [layer setBorderColor: [[UIColor whiteColor] CGColor]];
    [layer setBorderWidth:4.0f];
    [layer setCornerRadius:12.0f];
    
    self.layer.shadowOpacity = 1.0f;
    self.layer.shadowOffset = CGSizeZero;
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowRadius = 5.0;
    
    
    
    self.layer.shadowPath = CGPathCreateWithRoundedRect(self.bounds,self.layer.cornerRadius,self.layer.cornerRadius,NULL);
    
    [self.layer setShouldRasterize:YES];
    [self.layer setRasterizationScale:[UIScreen mainScreen].scale];
    
    return self;
}

#pragma mark - Setup Method
- (void)setupImageView
{
    // Clip subviews
    self.clipsToBounds = YES;
    
    // Add image subview
    CGRect ogRect = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, IMAGE_HEIGHT, self.bounds.size.height);
    
    self.MJImageView = [[UIImageView alloc] initWithFrame:ogRect];
    self.MJImageView.backgroundColor = [UIColor redColor];
    self.MJImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.MJImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    self.MJImageView.clipsToBounds = NO;
    [self addSubview:self.MJImageView];
}

# pragma mark - Setters

- (void)setImage:(UIImage *)image
{
    // Store image
    self.MJImageView.image = image;
    
    // Update padding
    [self setImageOffset:self.imageOffset];
}

- (void)setImageOffset:(CGPoint)imageOffset
{
    // Store padding value
    _imageOffset = imageOffset;
    
    // Grow image view
    CGRect frame = self.MJImageView.bounds;
    CGRect offsetFrame = CGRectOffset(frame, _imageOffset.x, _imageOffset.y);
    self.MJImageView.frame = offsetFrame;
}

#pragma mark - Overridden Methods

-(void)prepareForReuse
{
    [super prepareForReuse];
    
    [self setImage:nil];
}


/*
 
 to get rounded rect and drop shadows

- (void)drawRect:(CGRect)rect
{
    self.layer.masksToBounds = NO;
    self.layer.shadowColor = [[UIColor whiteColor] CGColor];
    self.layer.shadowOffset = CGSizeMake(0,2);
    self.layer.shadowRadius = 2;
    self.layer.shadowOpacity = 0.2;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(20, 20)];
    [[UIColor blackColor] setFill];
    
    [path fill];
}

*/



@end
