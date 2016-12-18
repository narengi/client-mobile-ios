//
//  MenuViewController.m
//  Narengi
//
//  Created by Morteza Hosseinizade on 11/9/15.
//  Copyright © 2015 Morteza Hosseinizade. All rights reserved.
//

#import "MenuViewController.h"
#import "REFrostedViewController.h"
#import "UIViewController+REFrostedViewController.h"

@interface MenuViewController ()

@property (weak, nonatomic) IBOutlet UIView *loginedView;
@property (weak, nonatomic) IBOutlet UIView *notLoginedView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImg;
@property (weak, nonatomic) IBOutlet UILabel *fullNameLabel;
@property (nonatomic,strong) UserObject *userObject;


@end

@implementation MenuViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
}

-(void)viewWillAppear:(BOOL)animated{

    NSString *currentToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"fuckingLoginedOrNOT"];
    
    if (currentToken != nil) {
        
        self.loginedView.hidden    = NO;
        self.notLoginedView.hidden = YES;
        self.userObject = [[ NSUserDefaults standardUserDefaults] rm_customObjectForKey:@"userObject"];
        
        self.fullNameLabel.text = [[self.userObject.fisrtName stringByAppendingString:@" "] stringByAppendingString:self.userObject.lastName];
        
        [SDWebImageDownloader.sharedDownloader setValue:[[NarengiCore sharedInstance] makeAuthurizationValue ] forHTTPHeaderField:@"authorization"];
        
        [self.avatarImg sd_setImageWithURL:self.userObject.avatarUrl placeholderImage:nil options:SDWebImageRefreshCached];
        
        self.avatarImg.layer.cornerRadius  = 25;
        self.avatarImg.layer.masksToBounds = YES;
        self.avatarImg.layer.borderWidth = 4;
        self.avatarImg.layer.borderColor = RGB(255, 88, 36, 1).CGColor;
        
    }
    else{
        
        self.loginedView.hidden    = YES;
        self.notLoginedView.hidden = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)registerClicked:(IranButton *)sender {
    
    [self goToRegister];
    [self.frostedViewController hideMenuViewController];
    
}

- (IBAction)profileButton:(UIButton *)sender {

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    UINavigationController *myProfileNav = [storyboard instantiateViewControllerWithIdentifier:@"myProfileNav"];
    [self presentViewController:myProfileNav animated:YES completion:nil];
    
}
- (IBAction)homeButtonClicked:(IranButton *)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    UINavigationController *navigationController = [storyboard instantiateViewControllerWithIdentifier:@"navRootVCID"];
    
    
//    LinesViewController *linesViewC = [self.storyboard instantiateViewControllerWithIdentifier:@"lineView"];
//    navigationController.viewControllers = @[linesViewC];
    self.frostedViewController.contentViewController = navigationController;
    [self.frostedViewController hideMenuViewController];
    
    
}
- (IBAction)hostingButtonClicked:(UIButton *)sender {
    
    NSString *currentToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"fuckingLoginedOrNOT"];

    if (currentToken != nil) {
//        self.frostedViewController.contentViewController = navigationController;
//        [self.frostedViewController hideMenuViewController];
        
        [self.frostedViewController hideMenuViewController];
        [self showHosting];
    }
    else
    {
        
        [self registerClicked:nil];
    }
    
    
}

-(void)showHosting{

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    UINavigationController *navigationController = [storyboard instantiateViewControllerWithIdentifier:@"hostingNaviagtionVCID"];
    
    [self presentViewController:navigationController animated:YES completion:nil];
    
}

- (IBAction)settingButtonClicked:(UIButton *)sender {
    
    [self showBetaAlert];
}
- (IBAction)guidButtonClciked:(id)sender {
    
    [self showBetaAlert];
}



@end
