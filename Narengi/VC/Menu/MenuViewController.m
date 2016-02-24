//
//  MenuViewController.m
//  Narengi
//
//  Created by Morteza Hosseinizade on 11/9/15.
//  Copyright © 2015 Morteza Hosseinizade. All rights reserved.
//

#import "MenuViewController.h"
#import "REFrostedViewController.h"

#import "UIViewController+REFrostedViewController.h"
@interface MenuViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)registerClicked:(IranButton *)sender {
    
    [self goToRegister];
    [self.frostedViewController hideMenuViewController];
    
}



@end
