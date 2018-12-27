//
//  CustomLabel.m
//  Narengi
//
//  Created by Morteza Hosseinizade on 12/7/15.
//  Copyright © 2015 Morteza Hosseinizade. All rights reserved.
//

#import "CustomLabel.h"

@implementation CustomLabel

-(void)awakeFromNib
{
    CGFloat fontSize = self.font.pointSize;
    self.font = [UIFont fontWithName:@"IRANSansMobileFaNum" size:fontSize-3];

}


//- (void)drawTextInRect:(CGRect)rect {
//    UIEdgeInsets insets = {10, 10, 5, 10};
//    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
//}

//-(CGSize)intrinsicContentSize{
//    CGSize contentSize = [super intrinsicContentSize];
//    return CGSizeMake(contentSize.width + 20, contentSize.height);
//}


@end
