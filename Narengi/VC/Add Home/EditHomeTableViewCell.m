//
//  EditHomeTableViewCell.m
//  Narengi
//
//  Created by Morteza Hoseinizade on 12/13/16.
//  Copyright © 2016 Morteza Hosseinizade. All rights reserved.
//

#import "EditHomeTableViewCell.h"

@implementation EditHomeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.indexLabel.layer.cornerRadius = 15;
    self.indexLabel.layer.masksToBounds = YES;
    
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
