//
//  BookFacilityTableViewCell.m
//  Narengi
//
//  Created by Morteza Hosseinizade on 3/10/16.
//  Copyright © 2016 Morteza Hosseinizade. All rights reserved.
//

#import "BookFacilityTableViewCell.h"

@implementation BookFacilityTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
