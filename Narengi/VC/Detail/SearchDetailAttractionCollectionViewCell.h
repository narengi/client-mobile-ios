//
//  SearchDetailAttractionCollectionViewCell.h
//  Narengi
//
//  Created by Morteza Hosseinizade on 12/10/15.
//  Copyright © 2015 Morteza Hosseinizade. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HWViewPager.h"
#import "PageCell.h"

@interface SearchDetailAttractionCollectionViewCell : UICollectionViewCell<UICollectionViewDataSource,UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIImageView *rateImg;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIButton *locationbutton;
@property (weak, nonatomic) IBOutlet UILabel *attractionLabel;

@property (nonatomic) NSArray *imageUrls;
@property (strong, nonatomic) HWViewPager *pages;
@end
