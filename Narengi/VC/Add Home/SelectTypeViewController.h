//
//  SelectTypeViewController.h
//  Narengi
//
//  Created by Morteza Hosseinizade on 5/9/16.
//  Copyright © 2016 Morteza Hosseinizade. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectTypeViewController : UIViewController

@property (nonatomic,strong) HouseObject *houseObj;
@property (nonatomic) BOOL isComingFromEdit;
@property (weak, nonatomic) IBOutlet UIView *containerView;

@end
