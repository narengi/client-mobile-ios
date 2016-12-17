//
//  StepViewController.h
//  Narengi
//
//  Created by Morteza Hosseinizade on 6/6/16.
//  Copyright © 2016 Morteza Hosseinizade. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StepLabel.h"

@interface StepViewController : UIViewController

@property (weak, nonatomic) IBOutlet StepLabel *fisrtLabel;
@property (weak, nonatomic) IBOutlet StepLabel *secondLabel;
@property (weak, nonatomic) IBOutlet StepLabel *thirdLabel;
@property (weak, nonatomic) IBOutlet StepLabel *fourthLabel;
@property (weak, nonatomic) IBOutlet StepLabel *fifthLabel;
@property (weak, nonatomic) IBOutlet StepLabel *sixthLabel;
@property (weak, nonatomic) IBOutlet StepLabel *seventhLabel;
@property (weak, nonatomic) IBOutlet StepLabel *eightthLabel;

@end
