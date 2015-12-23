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


-(void)changeLeftIcontoBack{

    UIImage *buttonImage = [UIImage imageNamed:@"BackBtnOrange"];
    UIButton *addbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addbutton setImage:buttonImage forState:UIControlStateNormal];
    addbutton.frame = CGRectMake(0, 0, 32, 32);
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:addbutton];
    self.navigationItem.leftBarButtonItem = customBarItem;
    [addbutton addTarget:self action:@selector(Back) forControlEvents:UIControlEventTouchUpInside];
}
-(void)Back {
    
    
    [self.navigationController popViewControllerAnimated:YES];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
}

#pragma mark - alerts and notifications

-(void)noConnection{
    
    
    [JDStatusBarNotification showWithStatus:@"اتصال به اینترنت را چک کنید!" dismissAfter:1 styleName:JDStatusBarStyleError];
    
}

#pragma mark -Navigation

-(void)goTodetailWithUrl:(NSString *)urlStr andWithType:(NSString *)type{

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];

    NSURL *url = [ NSURL URLWithString:urlStr];
    
    id destinationVC;
    
    if ([type isEqualToString:@"House"]) {
        
        destinationVC = (HouseDetailViewController *)[storyboard instantiateViewControllerWithIdentifier:@"houseDetailVCID"];
        ((HouseDetailViewController *)destinationVC).url  = url;
        
    }
    else if ([type isEqualToString:@"Attraction"]) {
        
        destinationVC = (AttractionDetailViewController *)[storyboard instantiateViewControllerWithIdentifier:@"attractionDetailVCID"];
        ((AttractionDetailViewController *)destinationVC).url  = url;
        
    }
    else  {
        
        destinationVC = (CityDetailViewController *)[storyboard instantiateViewControllerWithIdentifier:@"cityDetailVCID"];
        ((CityDetailViewController *)destinationVC).url  = url;
        
        
    }
    
    
    [self.navigationController pushViewController:destinationVC animated:YES];

    
    
}


@end
