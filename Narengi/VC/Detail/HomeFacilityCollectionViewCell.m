//
//  HomeFacilityCollectionViewCell.m
//  Narengi
//
//  Created by Morteza Hosseinizade on 1/7/16.
//  Copyright © 2016 Morteza Hosseinizade. All rights reserved.
//

#import "HomeFacilityCollectionViewCell.h"

@implementation HomeFacilityCollectionViewCell

-(void)awakeFromNib
{
    
    [self.titleLabel setTransform:CGAffineTransformMakeScale(-1, 1)];
    [self.img setTransform:CGAffineTransformMakeScale(-1, 1)];


}
@end
