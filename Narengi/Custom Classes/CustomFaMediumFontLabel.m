//
//  CustomFaMediumFontLabel.m
//  Narengi
//
//  Created by Morteza Hosseinizade on 12/10/15.
//  Copyright © 2015 Morteza Hosseinizade. All rights reserved.
//

#import "CustomFaMediumFontLabel.h"

@implementation CustomFaMediumFontLabel



-(void)awakeFromNib
{
    CGFloat fontSize = self.font.pointSize;
    self.font = [UIFont fontWithName:@"IRANSansMobileFaNum-Medium" size:fontSize];
    
}

@end
