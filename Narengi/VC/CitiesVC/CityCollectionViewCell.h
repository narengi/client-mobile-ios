//
//  CityCollectionViewCell.h
//  Narengi
//
//  Created by Morteza Hosseinizade on 12/2/15.
//  Copyright © 2015 Morteza Hosseinizade. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HWViewPager.h"

@interface CityCollectionViewCell : UICollectionViewCell <UICollectionViewDataSource,UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (nonatomic,strong) UICollectionView *collectionView;

@property (strong, nonatomic)  HWViewPager *pages;
@property NSArray *imageUrls;
@property CGRect frameC;
@property (weak, nonatomic) IBOutlet UIView *belowContentView;


@end
