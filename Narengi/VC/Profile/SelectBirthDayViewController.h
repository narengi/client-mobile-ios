//
//  SelectBirthDayViewController.h
//  Narengi
//
//  Created by Morteza Hosseinizade on 2/19/16.
//  Copyright © 2016 Morteza Hosseinizade. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectBirthDayViewController : UIViewController

@property (nonatomic,strong) NSString *selectedDateStr;
@property (nonatomic,strong) NSDate *previousDate;
@property (nonatomic ) BOOL didSelectDate;

@end
