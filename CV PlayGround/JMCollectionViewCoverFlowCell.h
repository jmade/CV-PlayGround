//
//  JMCollectionViewCoverFlowCell.h
//  CV PlayGround
//
//  Created by Justin Madewell on 5/17/14.
//  Copyright (c) 2014 Justin Madewell. All rights reserved.
//

#import <UIKit/UIKit.h>
#define IMAGE_HEIGHT 200
#define IMAGE_OFFSET_SPEED 25

@interface JMCollectionViewCoverFlowCell : UICollectionViewCell

@property (nonatomic, strong, readwrite) UIImage *image;
@property (nonatomic, assign, readwrite) CGPoint imageOffset;






@end
