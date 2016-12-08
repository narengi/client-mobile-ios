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
@property (weak, nonatomic) IBOutlet UIView *registerTextFieldContainer;
@property (weak, nonatomic) IBOutlet UITextField *registerEmailTextfield;
@property (weak, nonatomic) IBOutlet UITextField *registerPasswordtextField;

@property (nonatomic) BOOL editingLogIn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *secondViewLeadingSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *secondViewTrailingSpace;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *firstViewLeadingSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fisrtViewtrailingSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *trigerDistance;


@end

@implementation LoginViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self setUpElements];
    
    
    self.loginButton.enabled  = NO;
    self.signUpButton.enabled = NO;
    
    self.secondViewLeadingSpace.constant = [UIScreen mainScreen].bounds.size.width;
    self.secondViewTrailingSpace.constant = -[UIScreen mainScreen].bounds.size.width;
    self.trigerDistance.constant  = ([UIScreen mainScreen].bounds.size.width/4) -12;
    
    
    self.editingLogIn = YES;
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];


}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

-(void)setUpElements{

    [self.loginButton setBorderWithColor:RGB(50, 160, 84, 1) andWithWidth:1 withCornerRadius:2];
    [self.signUpButton setBorderWithColor:RGB(50, 160, 84, 1) andWithWidth:1 withCornerRadius:2];
    
    [self.textFieldsContainer setBorderWithColor:RGB(235, 235, 235, 1) andWithWidth:1 withCornerRadius:2];
    
    [self.registerTextFieldContainer setBorderWithColor:RGB(235, 235, 235, 1) andWithWidth:1 withCornerRadius:2];
    
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
    
    
}

- (IBAction)textFiedlChanged:(UITextField *)sender {
    
    if (self.editingLogIn) {
       
        NSString *emailStr = [self.emailTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSString *passStr = [self.passwordTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        if (emailStr.length > 0 && passStr.length > 0) {
            
            self.loginButton.enabled = YES;
        }
        else{
            self.loginButton.enabled = NO;
        }
    }
    else{
        
        NSString *emailStr = [self.registerEmailTextfield.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSString *passStr = [self.registerPasswordtextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        if (emailStr.length > 0 && passStr.length > 0) {
            
            self.signUpButton.enabled = YES;
        }
        else{
            self.signUpButton.enabled = NO;
        }
    
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
                
                UserObject *userObj = [[NarengiCore sharedInstance ] parsUserObject:response.backData ];
                
                [[NSUserDefaults standardUserDefaults] setObject:   [[response.backData objectForKey:@"token"] objectForKey:@"token"] forKey:@"fuckingLoginedOrNOT"];
                
                [[NSUserDefaults standardUserDefaults] setObject:[response.backData objectForKey:@"username"] forKey:@"loginedUser"];
                
                [[NSUserDefaults standardUserDefaults] rm_setCustomObject:userObj forKey:@"userObject"];

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
                    [self showError:erroStr];
                }
                else{
                    
                    [self showError:@"اشکال در ارتباط با سرور"];
                    
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
        bodyDict = @{@"email": self.registerEmailTextfield.text,@"password": self.registerPasswordtextField.text};
        
    }
    NSData *bodyData = [NSJSONSerialization dataWithJSONObject:bodyDict options:0 error:nil];


    
    return bodyData;

}

#pragma mark - navigation

- (IBAction)selectLogInButton:(UIButton *)sender {
    
    
    self.trigerDistance.constant  = ([UIScreen mainScreen].bounds.size.width/4)-12;
    
    self.secondViewLeadingSpace.constant = [UIScreen mainScreen].bounds.size.width;
    self.secondViewTrailingSpace.constant = -[UIScreen mainScreen].bounds.size.width;
    
    self.fisrtViewtrailingSpace.constant = 0;
    self.firstViewLeadingSpace.constant = 0;
    
    
    [UIView animateWithDuration:.5
                     animations:^{
                         [self.view layoutIfNeeded];
                     }];
    self.editingLogIn = YES;
}
- (IBAction)selectRegisterButton:(UIButton *)sender {
    
    
    self.trigerDistance.constant  =  ([UIScreen mainScreen].bounds.size.width / 4 * 3)-12;
    
    self.secondViewLeadingSpace.constant = 0;
    self.secondViewTrailingSpace.constant = 0;
    
    self.fisrtViewtrailingSpace.constant = [UIScreen mainScreen].bounds.size.width;
    self.firstViewLeadingSpace.constant = -[UIScreen mainScreen].bounds.size.width;
    
    
    [UIView animateWithDuration:.5
                     animations:^{
                         [self.view layoutIfNeeded];
                     }];
    
    self.editingLogIn = NO;
}



@end
