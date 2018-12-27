//
//  CommentDetailTableViewCell.m
//  Narengi
//
//  Created by Morteza Hosseinizade on 1/14/16.
//  Copyright © 2016 Morteza Hosseinizade. All rights reserved.
//

#import "CommentDetailTableViewCell.h"

@implementation CommentDetailTableViewCell

- (void)awakeFromNib {
    
    
    self.avatarImg.layer.cornerRadius  = 14.5;
    self.avatarImg.layer.masksToBounds = YES;
    self.avatarImg.layer.borderWidth = 1;
    self.avatarImg.layer.borderColor = [UIColor whiteColor].CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
