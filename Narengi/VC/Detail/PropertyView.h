//
//  PropertyView.h
//  Narengi
//
//  Created by Morteza Hosseinizade on 1/7/16.
//  Copyright © 2016 Morteza Hosseinizade. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PropertyView : UIView
@property (weak, nonatomic) IBOutlet UILabel *bedCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *guestCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *roomcountLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;

@end
