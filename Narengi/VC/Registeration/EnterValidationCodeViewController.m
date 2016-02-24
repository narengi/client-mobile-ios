//
//  EnterValidationCodeViewController.m
//  Narengi
//
//  Created by Morteza Hosseinizade on 2/23/16.
//  Copyright © 2016 Morteza Hosseinizade. All rights reserved.
//

#import "EnterValidationCodeViewController.h"

@interface EnterValidationCodeViewController ()
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UIView *textFieldContainerView;

@end

@implementation EnterValidationCodeViewController

- (void)viewDidLoad {
    
    [self.sendButton setBorderWithColor:RGB(50, 160, 84, 1) andWithWidth:1 withCornerRadius:2];
    [self.textFieldContainerView setBorderWithColor:RGB(235, 235, 235, 1) andWithWidth:1 withCornerRadius:2];
    [self changeLeftIcontoBack];
    self.title  = @"تایید تلفن همراه";
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - textField
- (IBAction)textFieldChanged:(UITextField *)sender {


}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(range.length + range.location > textField.text.length)
    {
        return NO;
        
    }
    
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return newLength <= 4;
    
    
}

#pragma mark - data
- (IBAction)sendCodeAgainButtonClicked:(UIButton *)sender {
}


- (IBAction)sendButtonclicked:(UIButton *)sender {
    
    REACHABILITY
    [self sendData];
}

-(void)sendData{

    [SVProgressHUD showWithStatus:@"در حال ارسال اطلاعات" maskType:SVProgressHUDMaskTypeGradient];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0),^{
        
        ServerResponse *response = [[NarengiCore sharedInstance] sendRequestWithMethod:@"POST" andWithService:[NSString stringWithFormat: @"accounts/verify/SMS/%@",self.codeTextField.text ] andWithParametrs:nil andWithBody:nil andIsFullPath:NO];
        
        dispatch_async(dispatch_get_main_queue(),^{
            
            
            [SVProgressHUD dismiss];
            
            if (!response.hasErro) {
                
                //Send user to enter code view
                [SVProgressHUD showSuccessWithStatus:@"شماره تلفن همراه شما فعال شد."];
                [self dismissViewControllerAnimated:YES completion:nil];
                
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



@end
