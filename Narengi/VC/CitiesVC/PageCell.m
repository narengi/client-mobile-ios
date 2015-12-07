//
//  PageCell.m
//  Narengi
//
//  Created by Morteza Hosseinizade on 11/12/15.
//  Copyright © 2015 Morteza Hosseinizade. All rights reserved.
//

#import "PageCell.h"

@implementation PageCell





-(void)awakeFromNib{

    self.backImageView.backgroundColor = [UIColor blackColor];
    self.backgroundColor               = [UIColor blackColor];
    
    self.backImageView.alpha = 0.75;
}
@end
