//
//  IdentificationViewController.m
//  Narengi
//
//  Created by Morteza Hosseinizade on 3/28/16.
//  Copyright © 2016 Morteza Hosseinizade. All rights reserved.
//

#import "IdentificationViewController.h"
#import "PhoneValidateViewController.h"

@interface IdentificationViewController ()
@property (weak, nonatomic) IBOutlet UIView *identificationCardImg;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (nonatomic,strong) UserObject *userObject;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIImageView *emailValidateImg;
@property (weak, nonatomic) IBOutlet UIImageView *phoneValidateImg;
@property (weak, nonatomic) IBOutlet UIImageView *idCardImg;

@end
@implementation IdentificationViewController


-(void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.containerView setBorderWithColor:RGB(158, 158 , 158, 1) andWithWidth:1 withCornerRadius:2];
    
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(validationChanged:) name:@"validationNotification" object:nil];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self checkValidation];

}

-(void)checkValidation{

    self.userObject = [[ NSUserDefaults standardUserDefaults] rm_customObjectForKey:@"userObject"];
    
    
    if (self.userObject.phoneVerification.isVerified) {
        
        self.phoneValidateImg.image = IMG(@"amenitieschecked");
    }
    else{
        self.phoneValidateImg.image = IMG(@"amenitiesoption");
        self.phoneLabel.text        = @"";

    }
    
    if (self.userObject.emailVerification.isVerified) {
        
        self.emailValidateImg.image = IMG(@"amenitieschecked");
    }
    else{
        self.emailValidateImg.image = IMG(@"amenitiesoption");
        self.emailLabel.text        = @"";
        
    }
    
    self.emailLabel.text = self.userObject.email;
    self.phoneLabel.text        = self.userObject.phoneVerification.handle;


    
    [SDWebImageDownloader.sharedDownloader setValue:[[NarengiCore sharedInstance] makeAuthurizationValue ] forHTTPHeaderField:@"authorization"];
    
    
    [self.idCardImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@accounts/id-card",BASEURL]] placeholderImage:nil options:SDWebImageRefreshCached];
}


#pragma mark - Notification

-(void)validationChanged:(NSNotification *) notification{

    [self checkValidation];
}
- (IBAction)phoneVerificationClicked:(UIButton *)sender {
    
    [self performSegueWithIdentifier:@"goToPhoneVerificationId" sender:nil];
    
}
- (IBAction)idCardVerificationClicked:(UIButton *)sender {
    
    [self goToIdCardVerification ];
    
}




@end
