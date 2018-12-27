//
//  DeleteHomeTableViewCell.m
//  Narengi
//
//  Created by Morteza Hoseinizade on 12/18/16.
//  Copyright © 2016 Morteza Hosseinizade. All rights reserved.
//

#import "DeleteHomeTableViewCell.h"

@implementation DeleteHomeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.deleteLabel.layer.cornerRadius = 4;
    self.deleteLabel.layer.borderColor = RGB(0, 0, 0, 0).CGColor;
    self.deleteLabel.layer.borderWidth = 1.0;
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

@end
