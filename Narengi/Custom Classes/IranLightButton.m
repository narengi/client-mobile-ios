//
//  IranLightButton.m
//  Narengi
//
//  Created by Morteza Hoseinizade on 12/18/16.
//  Copyright © 2016 Morteza Hosseinizade. All rights reserved.
//

#import "IranLightButton.h"

@implementation IranLightButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


-(void)awakeFromNib
{
    
    CGFloat fontSize = self.titleLabel.font.pointSize;

    self.titleLabel.font  = [UIFont fontWithName:@"IRANSansMobileFaNum-Light" size:fontSize];
    
    [super awakeFromNib];
}
@end
