//
//  CustomFaTextField.m
//  Narengi
//
//  Created by Morteza Hosseinizade on 3/3/16.
//  Copyright © 2016 Morteza Hosseinizade. All rights reserved.
//

#import "CustomFaTextField.h"

@implementation CustomFaTextField

-(void)awakeFromNib
{
    
    self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder
                                                                 attributes:@{
                                                                              NSForegroundColorAttributeName: RGB(224, 224, 224, 1),
                                                                              NSFontAttributeName : [UIFont fontWithName:@"IRANSansMobileFaNum" size:12]}];
    
    
    self.font  = [UIFont fontWithName:@"IRANSansMobileFaNum" size:13];
    
}
@end
