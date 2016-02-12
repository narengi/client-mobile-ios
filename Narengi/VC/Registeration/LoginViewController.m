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
    
     [self.emailTextField addTarget:self action:@selector(textDidChanged:) forControlEvents:UIControlEventEditingChanged];
     [self.passwordTextField addTarget:self action:@selector(textDidChanged:) forControlEvents:UIControlEventEditingChanged];
    
    self.loginButton.enabled = NO;
    
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

-(void)setUpElements{

    [self.loginButton setBorderWithColor:RGB(50, 160, 84, 1) andWithWidth:1 withCornerRadius:2];
    [self.signUpButton setBorderWithColor:RGB(244, 51, 0, 1) andWithWidth:1 withCornerRadius:2];
    
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

#pragma mark - textField

- (void)textDidChanged:(UITextField *)textField
{
    
    NSString *emailStr = [self.emailTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *passStr = [self.passwordTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if (emailStr.length > 0 && passStr.length > 0) {
        
        self.loginButton.enabled = YES;
    }
    else{
        self.loginButton.enabled = NO;
    }
}



#pragma mark - data

- (IBAction)loginButtonClicked:(IranButton *)sender {

    REACHABILITY
    [self sendDataWithType:@"login"];
}

- (IBAction)signUpButtonClicked:(IranButton *)sender {
    
    REACHABILITY
    [self sendDataWithType:@"register"];
}



-(void)sendDataWithType:(NSString *)type{


    
    [SVProgressHUD showWithStatus:@"در حال ارسال اطلاعات" maskType:SVProgressHUDMaskTypeGradient];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0),^{
        
       ServerResponse *response = [[NarengiCore sharedInstance] sendRequestWithMethod:@"POST" andWithService:[NSString stringWithFormat: @"accounts/%@" ,type] andWithParametrs:nil andWithBody:[self makeJsonWithType:type] andIsFullPath:NO];
        
        dispatch_async(dispatch_get_main_queue(),^{
            
            
            [SVProgressHUD dismiss];

            if (!response.hasErro) {
                
                
                //Send Request For Get Status
                
                UserObject *userObj = [[NarengiCore sharedInstance ] parsUserObject:response.backData];
                
                [[NSUserDefaults standardUserDefaults] setObject:[response.backData objectForKey:@"token"] forKey:@"fuckingLoginedOrNOT"];

                if (userObj.completePercent > 70) {
                    
                    [self dismissViewControllerAnimated:YES completion:nil];
                }
                else{
                
                    [self performSegueWithIdentifier:@"goToCompleteProfile" sender:nil];
                    
                
               }
                
            }
            else{
                
                if (response.backData != nil ) {
                   
                    //show error
                    NSString *erroStr = [[response.backData objectForKey:@"error"] objectForKey:@"message"];
                    [self showErro:erroStr];
                }
                else{
                    
                    [self showErro:@"اشکال در ارتباط با سرور"];
                    
                }
                
            }
        });
        
    });
    
}



-(NSData *)makeJsonWithType:(NSString *)type{

    
    NSDictionary* bodyDict ;
    
    if ([type isEqualToString:@"login"]) {
        bodyDict = @{@"username": self.emailTextField.text,@"password": self.passwordTextField.text};
    }
    else{
        bodyDict = @{@"email": self.emailTextField.text,@"password": self.passwordTextField.text};
        
    }
    NSData *bodyData = [NSJSONSerialization dataWithJSONObject:bodyDict options:0 error:nil];

    
    return bodyData;

}


@end
