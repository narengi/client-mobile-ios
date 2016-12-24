//
//  PriceCustomTextfield.m
//  Narengi
//
//  Created by Morteza Hoseinizade on 12/24/16.
//  Copyright © 2016 Morteza Hosseinizade. All rights reserved.
//

#import "PriceCustomTextfield.h"

@implementation PriceCustomTextfield

-(void)awakeFromNib
{
//    
//    self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder
//                                                                 attributes:@{
//                                                                              NSForegroundColorAttributeName: RGB(224, 224, 224, 1),
//                                                                              NSFontAttributeName : [UIFont fontWithName:@"IRANSansMobile" size:14]}];
    
    
    self.font  = [UIFont fontWithName:@"IRANSansMobileFaNum" size:17];
    
    [super awakeFromNib];
}

@end
