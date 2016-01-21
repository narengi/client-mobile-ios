//
//  CustomMarginLabel.h
//  Narengi
//
//  Created by Morteza Hosseinizade on 1/21/16.
//  Copyright © 2016 Morteza Hosseinizade. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomMarginLabel : UILabel

@property (nonatomic, assign) UIEdgeInsets edgeInsets;

@property (nonatomic, assign) IBInspectable CGFloat leftEdge;
@property (nonatomic, assign) IBInspectable CGFloat rightEdge;
@property (nonatomic, assign) IBInspectable CGFloat topEdge;
@property (nonatomic, assign) IBInspectable CGFloat bottomEdge;

@end
