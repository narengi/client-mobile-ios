//
//  PhoneValidateViewController.m
//  Narengi
//
//  Created by Morteza Hosseinizade on 2/21/16.
//  Copyright © 2016 Morteza Hosseinizade. All rights reserved.
//

#import "PhoneValidateViewController.h"
#import "EnterValidationCodeViewController.h"

@interface PhoneValidateViewController ()

@property (weak, nonatomic) IBOutlet UIView *phoneTextFieldContainerView;
@property (weak, nonatomic) IBOutlet UIButton *submiteButton;

@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (nonatomic,strong) UserObject *userObject;
@property (nonatomic,strong) NSString *phoneStr;

@end

@implementation PhoneValidateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.userObject = [[ NSUserDefaults standardUserDefaults] rm_customObjectForKey:@"userObject"];

     self.phoneStr = self.userObject.phoneVerification.handle;
    [self.submiteButton setBorderWithColor:RGB(50, 160, 84, 1) andWithWidth:1 withCornerRadius:2];
    [self.phoneTextFieldContainerView setBorderWithColor:RGB(235, 235, 235, 1) andWithWidth:1 withCornerRadius:2];
    self.phoneTextField.text = self.phoneStr;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self changeLeftIcontoBack];
    [self ChangeRightButtonToSkipCurrentStep];
    
    self.title  = @"تایید تلفن همراه";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)tectFieldChanged:(UITextField *)sender {
}

- (IBAction)enterButtonClicked:(UIButton *)sender {
    
    
}


#pragma mark - data


- (IBAction)submiteButtonClicked:(UIButton *)sender {
    
    REACHABILITY
    [self sendPhoneVerificationCode];
}

-(void)sendPhoneVerificationCode{

    
    [SVProgressHUD showWithStatus:@"در حال ارسال اطلاعات" maskType:SVProgressHUDMaskTypeGradient];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0),^{
        
        ServerResponse *response = [[NarengiCore sharedInstance] sendRequestWithMethod:@"POST" andWithService:@"accounts/verifications/request/SMS" andWithParametrs:nil andWithBody:[self makeJson] andIsFullPath:NO];
        
        dispatch_async(dispatch_get_main_queue(),^{
            
            
            [SVProgressHUD dismiss];
            
            if (!response.hasErro) {
                
                //Send user to enter code view
                [SVProgressHUD showSuccessWithStatus:@"کد فعال سازی برای شما ارسال شد."];
                [self sendUserToNextView];
                
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

-(NSData *)makeJson{


    NSData *bodyData = [NSJSONSerialization dataWithJSONObject:@{@"handle":self.phoneTextField.text} options:0 error:nil];
    
    
    return bodyData;
}

-(void)sendUserToNextView{

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    EnterValidationCodeViewController *destinationVC = [storyboard instantiateViewControllerWithIdentifier:@"enterValidationCodeVCID"];
    destinationVC.phoneStr = self.phoneTextField.text;
    [self.navigationController pushViewController:destinationVC animated:YES];
    
}




@end
