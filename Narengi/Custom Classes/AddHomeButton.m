//
//  AddHomeButton.m
//  Narengi
//
//  Created by Morteza Hosseinizade on 6/10/16.
//  Copyright © 2016 Morteza Hosseinizade. All rights reserved.
//

#import "AddHomeButton.h"

@implementation AddHomeButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)awakeFromNib{

    self.layer.borderColor = [self.titleLabel.textColor CGColor];
    self.layer.borderWidth = 2;
    
    self.layer.cornerRadius  = 4;
    self.layer.masksToBounds = YES;
    
    
    CGFloat fontSize = self.titleLabel.font.pointSize;
    self.titleLabel.font = [UIFont fontWithName:@"IRANSansMobileFaNum-Medium" size:fontSize-3];
}

@end
