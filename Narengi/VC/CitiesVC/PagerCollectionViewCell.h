//
//  PagerCollectionViewCell.h
//  Narengi
//
//  Created by Morteza Hosseinizade on 11/12/15.
//  Copyright © 2015 Morteza Hosseinizade. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HWViewPager.h"

@interface PagerCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet HWViewPager *pages;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property NSInteger row;
@end
