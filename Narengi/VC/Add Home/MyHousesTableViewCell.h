//
//  MyHousesTableViewCell.h
//  Narengi
//
//  Created by Morteza Hosseinizade on 6/13/16.
//  Copyright © 2016 Morteza Hosseinizade. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyHousesTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet CustomFaLightLabel *houseTypeLabel;
@property (weak, nonatomic) IBOutlet CustomFaLightLabel *bedCountLabel;
@property (weak, nonatomic) IBOutlet CustomFaLightLabel *roomCountLabel;
@property (weak, nonatomic) IBOutlet IranButton *editButton;
@property (weak, nonatomic) IBOutlet IranButton *deleteButton;
@property (weak, nonatomic) IBOutlet IranButton *viewButton;
@property (weak, nonatomic) IBOutlet CustomFaRegularLabel *availableFirstDay;

@end
