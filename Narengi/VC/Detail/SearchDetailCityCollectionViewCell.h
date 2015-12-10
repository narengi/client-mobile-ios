//
//  SearchDetailCityCollectionViewCell.h
//  Narengi
//
//  Created by Morteza Hosseinizade on 12/10/15.
//  Copyright © 2015 Morteza Hosseinizade. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HWViewPager.h"
#import "PageCell.h"

@interface SearchDetailCityCollectionViewCell : UICollectionViewCell<UICollectionViewDataSource,UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet CustomFaBoldLabel *nameLabel;
@property (weak, nonatomic) IBOutlet CustomFaMediumFontLabel *summeryLabel;

@property (weak, nonatomic) IBOutlet UIImageView *rateImg;
@property (weak, nonatomic) IBOutlet CustomFaMediumFontLabel *residentCountLabel;
@property (weak, nonatomic) IBOutlet CustomFaRegularLabel *desciptionLabel;

@property (nonatomic) NSArray *imageUrls;
@property (strong, nonatomic) HWViewPager *pages;
@property (weak, nonatomic) IBOutlet UIView *containerView;

@end
