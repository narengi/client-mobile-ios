//
//  SuccessReserveViewController.m
//  Narengi
//
//  Created by Morteza Hosseinizade on 4/28/16.
//  Copyright © 2016 Morteza Hosseinizade. All rights reserved.
//

#import "SuccessReserveViewController.h"

@interface SuccessReserveViewController ()
@property (weak, nonatomic) IBOutlet IranButton *closeButton;

@end

@implementation SuccessReserveViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.closeButton setBorderWithColor:RGB(181, 181 , 181, 1) andWithWidth:1 withCornerRadius:2];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)closebuttonClicked:(IranButton *)sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"paymentNotificationRecived" object:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}



@end
