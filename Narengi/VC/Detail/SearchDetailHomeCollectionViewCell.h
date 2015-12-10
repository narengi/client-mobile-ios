//
//  SearchDetailHomeCollectionViewCell.h
//  Narengi
//
//  Created by Morteza Hosseinizade on 12/10/15.
//  Copyright © 2015 Morteza Hosseinizade. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HWViewPager.h"
#import "PageCell.h"

@interface SearchDetailHomeCollectionViewCell : UICollectionViewCell<UICollectionViewDataSource,UICollectionViewDelegate>


@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIButton *locationButton;

@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UIImageView *rateImg;
@property (weak, nonatomic) IBOutlet UIImageView *coverImg;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerHeightConstrain;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerWidthConstrain;

@property (strong, nonatomic) HWViewPager *pages;

@property (nonatomic) NSArray *imageUrls;



@end
