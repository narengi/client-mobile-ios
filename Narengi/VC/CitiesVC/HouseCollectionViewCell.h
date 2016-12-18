//
//  HouseCollectionViewCell.h
//  Narengi
//
//  Created by Morteza Hosseinizade on 12/7/15.
//  Copyright © 2015 Morteza Hosseinizade. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HWViewPager.h"
#import "PageCell.h"



@interface HouseCollectionViewCell : UICollectionViewCell <UICollectionViewDataSource,UICollectionViewDelegate>


@property (weak, nonatomic) IBOutlet THLabel *titleLabel;
@property (weak, nonatomic) IBOutlet THLabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet CustomLabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *featuresLabel;


@property (strong, nonatomic) HWViewPager *pages;

@property (nonatomic) NSArray *imageUrls;

@property (weak, nonatomic ) IBOutlet UIView  *belowContentView;
@property (nonatomic,strong) UICollectionView *collectionView;


@end



