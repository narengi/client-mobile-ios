//
//  OwnerTableViewCell.m
//  Narengi
//
//  Created by Morteza Hosseinizade on 1/7/16.
//  Copyright © 2016 Morteza Hosseinizade. All rights reserved.
//

#import "OwnerTableViewCell.h"

@implementation OwnerTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
