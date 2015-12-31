//
//  CityDetailButton.m
//  Narengi
//
//  Created by Morteza Hosseinizade on 12/31/15.
//  Copyright © 2015 Morteza Hosseinizade. All rights reserved.
//

#import "CityDetailButton.h"

@implementation CityDetailButton

-(void)awakeFromNib
{
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds  = YES;
    self.layer.borderWidth = 0.5;
    self.layer.borderColor = [RGB(253, 128, 35, 1) CGColor];
    self.titleLabel.font  = [UIFont fontWithName:@"IRANSansMobileFaNum" size:10];
}

@end
