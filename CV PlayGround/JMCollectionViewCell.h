//
//  JMCollectionViewCell.h
//  CV PlayGround
//
//  Created by Justin Madewell on 5/14/14.
//  Copyright (c) 2014 Justin Madewell. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JMCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *cellLabel;

-(void)setLabelString:(NSString *)labelString;

@end
