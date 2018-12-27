//
//  ProfileSubViewContainer.m
//  Narengi
//
//  Created by Morteza Hosseinizade on 3/3/16.
//  Copyright © 2016 Morteza Hosseinizade. All rights reserved.
//

#import "ProfileSubViewContainer.h"

@implementation ProfileSubViewContainer




-(void)awakeFromNib
{
    
    self.layer.borderWidth = 1;
    self.layer.borderColor = RGB(235, 235, 235,1).CGColor;
    self.layer.cornerRadius = 2;

}


@end
