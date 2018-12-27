//
//  CustomFaLightLabel.m
//  Narengi
//
//  Created by Morteza Hosseinizade on 12/10/15.
//  Copyright © 2015 Morteza Hosseinizade. All rights reserved.
//

#import "CustomFaLightLabel.h"

@implementation CustomFaLightLabel

-(void)awakeFromNib
{
    CGFloat fontSize = self.font.pointSize;
    self.font = [UIFont fontWithName:@"IRANSansMobileFaNum-Light" size:fontSize];
    
}


@end
