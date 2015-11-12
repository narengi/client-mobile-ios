//
//  RootViewController.m
//  Narengi
//
//  Created by Morteza Hosseinizade on 11/9/15.
//  Copyright © 2015 Morteza Hosseinizade. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (void)awakeFromNib
{
    self.frostedViewController.direction = REFrostedViewControllerDirectionRight;
    self.frostedViewController.blurTintColor = [UIColor redColor];
    self.frostedViewController.blurRadius = 20;
    self.contentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"navRootVCID"];
    self.menuViewController    = [self.storyboard instantiateViewControllerWithIdentifier:@"menuVCID"];

}



@end
