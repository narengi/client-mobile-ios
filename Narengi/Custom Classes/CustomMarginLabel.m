//
//  CustomMarginLabel.m
//  Narengi
//
//  Created by Morteza Hosseinizade on 1/21/16.
//  Copyright © 2016 Morteza Hosseinizade. All rights reserved.
//

#import "CustomMarginLabel.h"

@implementation CustomMarginLabel


-(void)awakeFromNib
{
    CGFloat fontSize = self.font.pointSize;
    self.font = [UIFont fontWithName:@"IRANSansMobileFaNum" size:fontSize];
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.edgeInsets = UIEdgeInsetsMake(self.topEdge, self.leftEdge, self.bottomEdge, self.rightEdge);
    }
    return self;
}

- (void)drawTextInRect:(CGRect)rect
{
    self.edgeInsets = UIEdgeInsetsMake(self.topEdge, self.leftEdge, self.bottomEdge, self.rightEdge);
    
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, self.edgeInsets)];
}

- (CGSize)intrinsicContentSize
{
    CGSize size = [super intrinsicContentSize];
    size.height += 30;
    return size;

}

@end
