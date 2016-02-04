//
//  LoginViewController.m
//  Narengi
//
//  Created by Morteza Hosseinizade on 2/4/16.
//  Copyright © 2016 Morteza Hosseinizade. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet IranButton *loginButton;
@property (weak, nonatomic) IBOutlet IranButton *forgetButton;
@property (weak, nonatomic) IBOutlet IranButton *signUpButton;
@property (weak, nonatomic) IBOutlet UIView *textFieldsContainer;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self setUpElements];

}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

-(void)setUpElements{

    [self.loginButton setBorderWithColor:RGB(50, 160, 84, 1) andWithWidth:1 withCornerRadius:2];
    [self.textFieldsContainer setBorderWithColor:RGB(235, 235, 235, 1) andWithWidth:1 withCornerRadius:2];
    
    NSAttributedString * nameAtStr = [[NSAttributedString alloc] initWithString:@"کلمه عبور خود را فراموش کرده‌اید؟ " attributes:@{NSForegroundColorAttributeName:RGB(118, 118, 118, 1)}];
    
    NSAttributedString * messageAtStr = [[NSAttributedString alloc] initWithString:@"آن را بازنشانی کنید" attributes:@{NSForegroundColorAttributeName:RGB(0, 0, 0, 1)}];
    
    NSMutableAttributedString *atText = [[NSMutableAttributedString alloc] initWithAttributedString: nameAtStr];
    
    [atText appendAttributedString:messageAtStr];
    
    [self.forgetButton setAttributedTitle:atText forState:UIControlStateNormal];
}

- (IBAction)closeButton:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
