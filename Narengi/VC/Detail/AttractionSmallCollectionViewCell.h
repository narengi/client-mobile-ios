//
//  AttractionSmallCollectionViewCell.h
//  Narengi
//
//  Created by Morteza Hosseinizade on 12/23/15.
//  Copyright © 2015 Morteza Hosseinizade. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AttractionSmallCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;
@property (weak, nonatomic) IBOutlet UIView      *coverView;
@end
