//
//  JMFooterView.m
//  CV PlayGround
//
//  Created by Justin Madewell on 5/14/14.
//  Copyright (c) 2014 Justin Madewell. All rights reserved.
//

#import "JMFooterView.h"

@implementation JMFooterView
@synthesize footerLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        footerLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
        footerLabel.textAlignment = NSTextAlignmentCenter;
        footerLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
        footerLabel.adjustsFontSizeToFitWidth = YES;
        footerLabel.numberOfLines = 1;
        footerLabel.text = @"Footer";
        footerLabel.textColor = [UIColor whiteColor];
        [self addSubview:footerLabel];
        
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
