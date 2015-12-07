//
//  AttractionCollectionViewCell.h
//  Narengi
//
//  Created by Morteza Hosseinizade on 12/2/15.
//  Copyright © 2015 Morteza Hosseinizade. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HWViewPager.h"
#import "PageCell.h"


@interface AttractionCollectionViewCell : UICollectionViewCell <UICollectionViewDataSource,UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet THLabel   *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel   *descriptionLabel;

@property (strong, nonatomic) HWViewPager *pages;
@property (nonatomic        ) NSArray     *imageUrls;
@property (nonatomic        ) CGRect      frameC;

@property (weak, nonatomic) IBOutlet UIView *belowContentView;
@property (nonatomic,strong) UICollectionView  *collectionView;


@end
