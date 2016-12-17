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
    
    self.containerView.layer.cornerRadius = 2;
    self.containerView.layer.masksToBounds = YES;
    
    
    self.priceLabel.layer.cornerRadius = 2;
    self.priceLabel.layer.masksToBounds = YES;
    
    self.containerView.layer.borderColor = RGB(193, 193, 193, 1).CGColor;
    self.containerView.layer.borderWidth = 1;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
