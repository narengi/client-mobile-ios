//
//  IranButton.m
//  ChanChan
//
//  Created by Morteza Hosseinizade on 11/28/15.
//  Copyright © 2015 Fardad Co. All rights reserved.
//

#import "IranButton.h"

@implementation IranButton

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
    self.titleLabel.font = [UIFont fontWithName:@"IRANSansMobileFaNum-Medium" size:fontSize-3];
    
}
@end
