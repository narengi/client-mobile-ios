//
//  RetyButton.m
//  Narengi
//
//  Created by Morteza Hoseinizade on 12/18/16.
//  Copyright © 2016 Morteza Hosseinizade. All rights reserved.
//

#import "RetyButton.h"

@implementation RetyButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)awakeFromNib
{

    self.layer.cornerRadius = 5;
    self.layer.masksToBounds  = YES;
    self.titleLabel.font  = [UIFont fontWithName:@"IRANSansMobileFaNum" size:10];
 
    [super awakeFromNib];
}
@end
