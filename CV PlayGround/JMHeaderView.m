//
//  JMHeaderView.m
//  CV PlayGround
//
//  Created by Justin Madewell on 5/14/14.
//  Copyright (c) 2014 Justin Madewell. All rights reserved.
//

#import "JMHeaderView.h"

@implementation JMHeaderView
@synthesize headerLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        headerLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
        headerLabel.textAlignment = NSTextAlignmentCenter;
        headerLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
        headerLabel.adjustsFontSizeToFitWidth = YES;
        headerLabel.numberOfLines = 1;
        headerLabel.text = @"Header";
        headerLabel.textColor = [UIColor whiteColor];
        [self addSubview:headerLabel];

        
        self.backgroundColor = [UIColor purpleColor];
    }
    return self;
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
