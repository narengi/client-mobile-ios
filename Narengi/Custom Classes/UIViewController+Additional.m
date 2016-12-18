//
//  UIViewController+Additional.m
//  Narengi
//
//  Created by Morteza Hosseinizade on 11/18/15.
//  Copyright © 2015 Morteza Hosseinizade. All rights reserved.
//

#import "UIViewController+Additional.h"
#import "JDStatusBarNotification.h"
#import "CityDetailViewController.h"
#import "AttractionDetailViewController.h"
#import "HouseDetailViewController.h"
#import "ProfileViewController.h"
#import "LoginViewController.h"
#import "BookViewController.h"
#import "VerficationRootViewController.h"
#import "IDCardValidateViewController.h"
#import "VerficationRootViewController.h"
#import "HouseDetailMapViewController.h"
#import "CityDetailMapViewController.h"
#import "REFrostedViewController.h"


@implementation UIViewController (Additional)


-(void)changeRightIcontoMap{

    UIButton *mapButton  = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
    [mapButton setImage:IMG(@"ResulsOnMap") forState:UIControlStateNormal];
    
    [mapButton addTarget:self action:@selector(goToFilter) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:mapButton];
    self.navigationItem.rightBarButtonItem = customBarItem;
    
}


-(void)goToFilter
{
    

    
}

-(void)changeRighNavigationToMenu{
    
    UIImage *buttonImage = [UIImage imageNamed:@"MenuIcon"];
    UIButton *menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [menuButton setImage:buttonImage forState:UIControlStateNormal];
    menuButton.frame = CGRectMake(0, 0, 32, 32);
    menuButton.contentEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 10);
    
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:menuButton];
    self.navigationItem.rightBarButtonItem = customBarItem;
    [menuButton addTarget:self action:@selector(showMenu) forControlEvents:UIControlEventTouchUpInside];
}

-(void)showMenu{

    [self.view endEditing:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    [self.frostedViewController.view endEditing:YES];
    [self.frostedViewController presentMenuViewController];
}
-(void)changeLeftIcontoBack{

    UIImage *buttonImage = [UIImage imageNamed:@"BackBtnOrange"];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:buttonImage forState:UIControlStateNormal];
    backButton.frame = CGRectMake(0, 0, 32, 32);
    backButton.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, -10);

    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.rightBarButtonItem = customBarItem;
    [backButton addTarget:self action:@selector(Back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}
-(void)Back {

    
    [self.navigationController popViewControllerAnimated:YES];
    
}


-(void)showBetaAlert{

    UIAlertController *buyAlert = [UIAlertController alertControllerWithTitle:nil
                                                                      message:@"ما سخت تلاش میکنیم که انجام این عملیات در نسخه بعدی برای شما فراهم شود. ممنون که از نسخه آزمایشی نارنگی استفاده میکنید"
                                                               preferredStyle:UIAlertControllerStyleAlert                   ];
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"تایید"
                         style:UIAlertActionStyleDestructive
                         handler:^(UIAlertAction * action)
                         
                         {
                             [buyAlert dismissViewControllerAnimated:YES completion:nil];
                             
                         }];
    
    
    [buyAlert addAction: ok];
    [self presentViewController:buyAlert animated:YES completion:nil];
}
#pragma mark - alerts and notifications

-(void)noConnection{
    
    
    [JDStatusBarNotification showWithStatus:@"اتصال به اینترنت را چک کنید!" dismissAfter:1 styleName:JDStatusBarStyleError];
    
}

-(void)showError:(NSString *)str{
    
    
    [JDStatusBarNotification showWithStatus:str dismissAfter:1.5 styleName:JDStatusBarStyleError];
    
}

#pragma mark -Navigation

-(void)goToDetailWithArroundObject:(AroundPlaceObject *)arroundObject{

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];

    NSString *type =  arroundObject.type;
    NSURL *url  = nil;
    
    
    id destinationVC;
    
    if ([type isEqualToString:@"House"]) {
        
        destinationVC = (HouseDetailViewController *)[storyboard instantiateViewControllerWithIdentifier:@"houseDetailVCID"];
        ((HouseDetailViewController *)destinationVC).url  = url;
        ((HouseDetailViewController *)destinationVC).houseID  = arroundObject.houseObject.ID;
        
        
    }
    else if ([type isEqualToString:@"Attraction"]) {
        
        destinationVC = (AttractionDetailViewController *)[storyboard instantiateViewControllerWithIdentifier:@"attractionDetailVCID"];
        ((AttractionDetailViewController *)destinationVC).url  = url;
        
    }
    else if ([type isEqualToString:@"City"]) {
        
        destinationVC = (CityDetailViewController *)[storyboard instantiateViewControllerWithIdentifier:@"cityDetailVCID"];
        ((CityDetailViewController *)destinationVC).url  = url;
        
        
    }
    else{
        
    }
    
    
    [self.navigationController pushViewController:destinationVC animated:YES];

    
    
}

-(void)goToProfileWithUrl:(NSString *)urlStr{

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ProfileViewController *profileVc  = [storyboard instantiateViewControllerWithIdentifier:@"prodileVCID"];
    profileVc.urlStr  = urlStr;
    
    [self.navigationController pushViewController:profileVc animated:YES];
}

#pragma mark - url

-(NSURL*)fixUrl:(NSURL *)url withParametrs:(NSArray *)parametrs{

    NSURLComponents *urlComponents = [[NSURLComponents alloc] initWithURL:[NSURL URLWithString:url.absoluteString]resolvingAgainstBaseURL:YES];
    
    NSMutableArray *muArr = [[NSMutableArray alloc ]initWithArray: urlComponents.queryItems];
    
    for (NSDictionary *parametr in parametrs) {
     
        NSURLQueryItem *item = [[NSURLQueryItem alloc] initWithName:[parametr objectForKey:@"name"] value:[parametr objectForKey:@"value"]];
        [muArr addObject:item];

    }
    
    urlComponents.queryItems = [muArr copy];
    
    return urlComponents.URL;
}




#pragma mark - Gradiant

-(void)insertGradientToView:(UIView *)view{
 
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = view.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor clearColor] CGColor], (id)[[UIColor blackColor] CGColor], nil];
    
    [view.layer insertSublayer:gradient atIndex:0];

}

-(void)goToRegisterORBookWithObject:(HouseObject *)houseObj{

    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"fuckingLoginedOrNOT"] != nil) {
        
        
        UserObject *userObject = [[ NSUserDefaults standardUserDefaults] rm_customObjectForKey:@"userObject"];
        if (userObject.phoneVerification.isVerified) {
          
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            
            UINavigationController *logInNavVC = [storyboard instantiateViewControllerWithIdentifier:@"bookNavigation"];
            [self presentViewController:logInNavVC animated:YES completion:^{
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"houseObjectForBokking" object:houseObj];
            }];
        }
        else
        {
            UIStoryboard *verificationStoeyBoard = [UIStoryboard storyboardWithName:@"Verification" bundle:nil];
            
            VerficationRootViewController *vc =  [verificationStoeyBoard instantiateViewControllerWithIdentifier:@"verificationRootVCID"];
            vc.isComingFromHouse = YES;
            
            UINavigationController *verificationNavigation = [[UINavigationController alloc] initWithRootViewController:vc];
            
            [self presentViewController:verificationNavigation animated:YES completion:nil];
        }
        
        
        
    }
    else{
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        UINavigationController *logInNavVC = [storyboard instantiateViewControllerWithIdentifier:@"registrationNav"];
        [self presentViewController:logInNavVC animated:YES completion:nil];
    }
}
-(void)goToRegister{
    
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    UINavigationController *logInNavVC = [storyboard instantiateViewControllerWithIdentifier:@"registrationNav"];
    [self presentViewController:logInNavVC animated:YES completion:nil];
    
}

-(void)registerCellWithName:(NSString *)name andWithIdentifier :(NSString *)identifier andTableView:(UITableView *)tableview{

    [tableview registerNib:[UINib nibWithNibName:name bundle:nil]  forCellReuseIdentifier:identifier];


}

-(void)changeRightIconToSkip{

    
    UIButton *skipButton  = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
    [skipButton setImage:IMG(@"CloseIconOrange") forState:UIControlStateNormal];
    
    [skipButton addTarget:self action:@selector(goToRoot) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:skipButton];
    self.navigationItem.rightBarButtonItem = customBarItem;
}

-(void)goToRoot{
 
    NSArray *viewControllers = [[self navigationController] viewControllers];
    for( int i=0;i<[viewControllers count];i++){
        id obj=[viewControllers objectAtIndex:i];
        if([obj isKindOfClass:[VerficationRootViewController class]]){
            [[self navigationController] popToViewController:obj animated:YES];
            return;
        }
    }
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)ChangeRightButtonToSkipCurrentStep{
    
    UIButton *skipButton  = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
    [skipButton setImage:IMG(@"CloseIconOrange") forState:UIControlStateNormal];
    
   UserObject *user = [[ NSUserDefaults standardUserDefaults] rm_customObjectForKey:@"userObject"];
    if (user.idCardVerification.isVerified) {
        [skipButton addTarget:self action:@selector(goToRoot) forControlEvents:UIControlEventTouchUpInside];

    }
    else{
        [skipButton addTarget:self action:@selector(goToIdCardVerification) forControlEvents:UIControlEventTouchUpInside];

        
    }

    
    
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:skipButton];
    self.navigationItem.rightBarButtonItem = customBarItem;
    
}
-(void)goToIdCardVerification{

    UIStoryboard *verificationStoeyBoard = [UIStoryboard storyboardWithName:@"Verification" bundle:nil];

    IDCardValidateViewController *vc =  [verificationStoeyBoard instantiateViewControllerWithIdentifier:@"idVerificationVCID"];
    [self.navigationController pushViewController:vc animated:YES];
}


-(void)changeRightIcontoDismiss{
    
    UIButton *closeButton  = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
    [closeButton setImage:IMG(@"CloseIconOrange") forState:UIControlStateNormal];
    
    [closeButton addTarget:self action:@selector(dismissVerification) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:closeButton];
    self.navigationItem.rightBarButtonItem = customBarItem;
    
}

-(void)dismissVerification{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark - goto map

-(void)gotoMapForHouseDetailwithGeo:(GeoPointObject *)geo{

    
    UIStoryboard *verificationStoeyBoard = [UIStoryboard storyboardWithName:@"Maps" bundle:nil];
    
    HouseDetailMapViewController *vc =  [verificationStoeyBoard instantiateViewControllerWithIdentifier:@"houseDetailMapVCID"];
    vc.geoPoint = geo;
    
    [self.navigationController showViewController:vc sender:nil];
}

-(void)gotoMapFromCityWithHouses:(NSArray *)houses andWithTitle:(NSString *)title{
    
    
    UIStoryboard *verificationStoeyBoard = [UIStoryboard storyboardWithName:@"Maps" bundle:nil];
    
    CityDetailMapViewController *vc =  [verificationStoeyBoard instantiateViewControllerWithIdentifier:@"cityDetailMapVCID"];
    vc.houseArr = houses;
    vc.titleStr = title;
    
    [self.navigationController showViewController:vc sender:nil];
}


-(void)changeRightButtonToClose{
    
    UIImage *buttonImage = [UIImage imageNamed:@"CloseIconOrange"];
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton setImage:buttonImage forState:UIControlStateNormal];
    closeButton.frame = CGRectMake(0, 0, 32, 32);
    closeButton.contentEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 10);
    
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:closeButton];
    self.navigationItem.leftBarButtonItem = customBarItem;
    [closeButton addTarget:self action:@selector(closeClicked) forControlEvents:UIControlEventTouchUpInside];
    
}
-(void)closeClicked{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
