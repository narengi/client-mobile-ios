//
//  AskForCompleteProfileViewController.m
//  Narengi
//
//  Created by Morteza Hosseinizade on 2/10/16.
//  Copyright © 2016 Morteza Hosseinizade. All rights reserved.
//

#import "AskForCompleteProfileViewController.h"

@interface AskForCompleteProfileViewController ()
@property (weak, nonatomic) IBOutlet IranButton *completeProfileButton;

@end

@implementation AskForCompleteProfileViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self.completeProfileButton setBorderWithColor:RGB(90, 90, 90, 1) andWithWidth:1 withCornerRadius:2];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)dismissButton:(IranButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)completeProfileButtonClicked:(IranButton *)sender {
    
    [self performSegueWithIdentifier:@"goToCompleteProfile" sender:nil];
}


@end
