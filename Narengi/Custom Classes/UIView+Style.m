//
//  UIView+Style.m
//  Narengi
//
//  Created by Morteza Hosseinizade on 2/4/16.
//  Copyright © 2016 Morteza Hosseinizade. All rights reserved.
//

#import "UIView+Style.h"

@implementation UIView (Style)


-(void)setBorderWithColor:(UIColor *)color andWithWidth:(NSInteger )width withCornerRadius:(CGFloat) radius{
    
    self.layer.borderWidth = width;
    self.layer.borderColor = color.CGColor;
    self.layer.cornerRadius = radius;
}
@end
