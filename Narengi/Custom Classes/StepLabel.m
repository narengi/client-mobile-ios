//
//  StepLabel.m
//  Narengi
//
//  Created by Morteza Hosseinizade on 6/6/16.
//  Copyright © 2016 Morteza Hosseinizade. All rights reserved.
//

#import "StepLabel.h"

@implementation StepLabel

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)awakeFromNib
{
    CGFloat fontSize = self.font.pointSize;
    self.font = [UIFont fontWithName:@"IRANSansMobileFaNum" size:fontSize-3];
    
    
    
}


@end
