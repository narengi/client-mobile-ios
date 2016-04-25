//
//  VerificationIntroViewController.m
//  Narengi
//
//  Created by Morteza Hosseinizade on 4/25/16.
//  Copyright © 2016 Morteza Hosseinizade. All rights reserved.
//

#import "VerificationIntroViewController.h"
#import "PhoneValidateViewController.h"

@interface VerificationIntroViewController ()
@property (weak, nonatomic) IBOutlet IranButton *startButton;
@property (nonatomic,strong) UserObject *userObject;


@end

@implementation VerificationIntroViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self.startButton setBorderWithColor:RGB(50, 160, 84, 1) andWithWidth:1 withCornerRadius:2];
    self.userObject = [[ NSUserDefaults standardUserDefaults] rm_customObjectForKey:@"userObject"];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (IBAction)startButtonclicked:(IranButton *)sender {
    
    
    if (self.userObject.phoneVerification.isVerified) {
        [self performSegueWithIdentifier:@"goDirectToVerificationID" sender:nil];

    }
    else
        [self performSegueWithIdentifier:@"goToPhoneVerificationID" sender:nil];

    
    [[NSUserDefaults standardUserDefaults] setObject:@"FuckingYeah" forKey:@"didSeeVerificationIntro"];
}




@end
