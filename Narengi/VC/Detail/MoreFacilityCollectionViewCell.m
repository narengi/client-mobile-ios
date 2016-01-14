//
//  MoreFacilityCollectionViewCell.m
//  Narengi
//
//  Created by Morteza Hosseinizade on 1/14/16.
//  Copyright © 2016 Morteza Hosseinizade. All rights reserved.
//

#import "MoreFacilityCollectionViewCell.h"

@implementation MoreFacilityCollectionViewCell

-(void)awakeFromNib
{
    [self.titleLabel setTransform:CGAffineTransformMakeScale(-1, 1)];
}
@end
