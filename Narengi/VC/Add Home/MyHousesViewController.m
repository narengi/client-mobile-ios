//
//  MyHousesViewController.m
//  Narengi
//
//  Created by Morteza Hosseinizade on 5/7/16.
//  Copyright © 2016 Morteza Hosseinizade. All rights reserved.
//

#import "MyHousesViewController.h"

@interface MyHousesViewController ()

@end

@implementation MyHousesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self changeLeftButton];
    [self changeRighNavigationToMenu];
    self.title = @"مهمان‌پذیری";

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)changeLeftButton{

    UIImage *buttonImage = [UIImage imageNamed:@"add-avatar"];
    UIButton *addbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addbutton setImage:buttonImage forState:UIControlStateNormal];
    addbutton.frame = CGRectMake(0, 0, 32, 32);
    addbutton.contentEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 10);
    
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:addbutton];
    self.navigationItem.leftBarButtonItem = customBarItem;
    [addbutton addTarget:self action:@selector(goToAddHome) forControlEvents:UIControlEventTouchUpInside];
}
-(void)goToAddHome{

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"AddHome" bundle:nil];
    
    UINavigationController *addHouseNavVC = [storyboard instantiateViewControllerWithIdentifier:@"addHomNavigationVC"];
    [self presentViewController:addHouseNavVC animated:YES completion:nil];
}
@end
