//
//  JMCollectionViewCell.m
//  CV PlayGround
//
//  Created by Justin Madewell on 5/14/14.
//  Copyright (c) 2014 Justin Madewell. All rights reserved.
//

#import "JMCollectionViewCell.h"

@implementation JMCollectionViewCell
@synthesize cellLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
//        self.contentView.layer.cornerRadius = CGRectGetWidth(self.contentView.bounds) / 4;
//        self.contentView.layer.borderWidth = 1.0f;
//        self.contentView.layer.borderColor = [UIColor whiteColor].CGColor;
//        self.contentView.backgroundColor = [UIColor underPageBackgroundColor];
        
        
        
        cellLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame))];
        cellLabel.textAlignment = NSTextAlignmentCenter;
        cellLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
        cellLabel.adjustsFontSizeToFitWidth = YES;
        cellLabel.numberOfLines = 1;
        cellLabel.text = @"test";
        cellLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:cellLabel];
        
        // Random Color
        CGFloat redValue = (arc4random() % 255) / 255.0f;
        CGFloat blueValue = (arc4random() % 255) / 255.0f;
        CGFloat greenValue = (arc4random() % 255) / 255.0f;
        UIColor *randomColor = [UIColor colorWithRed:redValue green:greenValue blue:blueValue alpha:1.0f];
        // End Random Color
        self.backgroundColor = randomColor;

           }
    return self;
}

-(void)prepareForReuse
{
    [super prepareForReuse];
    
    [self setLabelString:@""];
    
    
}

-(void)setLabelString:(NSString *)labelString
{
    self.cellLabel.text = labelString;
}

-(void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes
{
    [super applyLayoutAttributes:layoutAttributes];
    self.cellLabel.center = CGPointMake(CGRectGetWidth(self.contentView.bounds) / 2.0f, CGRectGetHeight(self.contentView.bounds) / 2.0f);
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
