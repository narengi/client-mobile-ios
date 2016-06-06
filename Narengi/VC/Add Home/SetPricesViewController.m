//
//  SetPricesViewController.m
//  Narengi
//
//  Created by Morteza Hosseinizade on 5/10/16.
//  Copyright © 2016 Morteza Hosseinizade. All rights reserved.
//

#import "SetPricesViewController.h"

@interface SetPricesViewController ()
@property (weak, nonatomic) IBOutlet UITextField *priceTextField;
@property (weak, nonatomic) IBOutlet UITextField *extraGuestPriceTextField;

@end

@implementation SetPricesViewController

- (void)viewDidLoad {
    
    [self changeLeftIcontoBack];
    [self changeRightButtonToClose];
    
    self.title = @"اجاره‌بها";
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)submitButtonClicked:(UIButton *)sender {
    
    if ([self.priceTextField.text integerValue] > 0) {
        
        if ([self.extraGuestPriceTextField.text integerValue] > 0) {
            
            self.houseObj.price = [self.priceTextField.text integerValue];
            self.houseObj.extraGuestPrice = [self.extraGuestPriceTextField.text integerValue];
            
            [self performSegueWithIdentifier:@"" sender:nil];
        }
        else{
            
            [self showError:@"لطفا هزینه مهمان‌اضافی را درست وارد کنید"];

        }
    }
    else{
        [self showError:@"لطفا هزینه اجاره‌بها را درست وارد کنید"];
    }
}
- (IBAction)preButtonClciked:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
