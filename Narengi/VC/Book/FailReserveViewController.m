//
//  FailReserveViewController.m
//  Narengi
//
//  Created by Morteza Hosseinizade on 4/28/16.
//  Copyright © 2016 Morteza Hosseinizade. All rights reserved.
//

#import "FailReserveViewController.h"

@interface FailReserveViewController ()
@property (weak, nonatomic) IBOutlet IranButton *closeButton;

@end

@implementation FailReserveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.closeButton setBorderWithColor:RGB(181, 181 , 181, 1) andWithWidth:1 withCornerRadius:2];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)closeButtonclicked:(IranButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
