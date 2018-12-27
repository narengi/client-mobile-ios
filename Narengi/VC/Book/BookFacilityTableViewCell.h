//
//  BookFacilityTableViewCell.h
//  Narengi
//
//  Created by Morteza Hosseinizade on 3/10/16.
//  Copyright © 2016 Morteza Hosseinizade. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BookFacilityTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet CustomFaRegularLabel *titleLabel;
@property (weak, nonatomic) IBOutlet CustomFaRegularLabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *stateImg;
@property (weak, nonatomic) IBOutlet UILabel *lineLabel;

@end
