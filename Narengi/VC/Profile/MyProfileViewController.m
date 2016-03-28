//
//  MyProfileViewController.m
//  Narengi
//
//  Created by Morteza Hosseinizade on 3/27/16.
//  Copyright © 2016 Morteza Hosseinizade. All rights reserved.
//

#import "MyProfileViewController.h"

@implementation MyProfileViewController


-(void)viewDidLoad

{
    [super viewDidLoad];
    
    self.title = @"پروفایل";
}

-(void)addLeftAndRightButton{

    
    UIButton *editButton  = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
    [editButton setImage:IMG(@"ResulsOnMap") forState:UIControlStateNormal];
    
    [editButton addTarget:self action:@selector(goToEdit) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:editButton];
    
    self.navigationItem.rightBarButtonItem = customBarItem;
    
    
    UIButton *closeButton  = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
    [closeButton setImage:IMG(@"CloseIconOrange") forState:UIControlStateNormal];
    
    [closeButton addTarget:self action:@selector(closeButton) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIBarButtonItem *closeBarItem = [[UIBarButtonItem alloc] initWithCustomView:closeButton];
    
    self.navigationItem.leftBarButtonItem = closeBarItem;

}

-(void)goToEdit{

}

-(void)closeButton{

    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
