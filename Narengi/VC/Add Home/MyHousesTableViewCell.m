//
//  MyHousesTableViewCell.m
//  Narengi
//
//  Created by Morteza Hosseinizade on 6/13/16.
//  Copyright © 2016 Morteza Hosseinizade. All rights reserved.
//

#import "MyHousesTableViewCell.h"

@implementation MyHousesTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
