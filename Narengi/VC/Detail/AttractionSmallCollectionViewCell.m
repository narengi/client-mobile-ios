//
//  AttractionSmallCollectionViewCell.m
//  Narengi
//
//  Created by Morteza Hosseinizade on 12/23/15.
//  Copyright © 2015 Morteza Hosseinizade. All rights reserved.
//

#import "AttractionSmallCollectionViewCell.h"

@implementation AttractionSmallCollectionViewCell


-(void)awakeFromNib{

    
    
    self.backImageView.backgroundColor = [UIColor blackColor];
    self.coverView.backgroundColor   = [UIColor blackColor];
    
    self.coverView.alpha = 0.4;
    
    self.backImageView.layer.cornerRadius =  5;
    self.backImageView.layer.masksToBounds = YES;
//    
    self.coverView.layer.cornerRadius =  5;
    self.coverView.layer.masksToBounds = YES;
    
    [self.backImageView setTransform:CGAffineTransformMakeScale(-1, 1)];
    [self.titleLabel setTransform:CGAffineTransformMakeScale(-1, 1)];

    
}
@end
