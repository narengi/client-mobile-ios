//
//  InsertNameAndDescriptionViewController.h
//  Narengi
//
//  Created by Morteza Hosseinizade on 5/6/16.
//  Copyright © 2016 Morteza Hosseinizade. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InsertNameAndDescriptionViewController : UIViewController

@property (nonatomic,strong) HouseObject *houseObj;
@property (weak, nonatomic) IBOutlet UIView *containerView;

@property (nonatomic) BOOL isComingFromEdit;

@end
