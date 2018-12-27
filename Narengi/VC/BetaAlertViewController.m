//
//  BetaAlertViewController.m
//  Narengi
//
//  Created by Morteza Hoseinizade on 12/30/16.
//  Copyright © 2016 Morteza Hosseinizade. All rights reserved.
//

#import "BetaAlertViewController.h"

@interface BetaAlertViewController ()
@property (weak, nonatomic) IBOutlet IranButton *closeButton;

@end

@implementation BetaAlertViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)closeButtonClicked:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
