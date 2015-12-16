//
//  UIViewController+Additional.m
//  Narengi
//
//  Created by Morteza Hosseinizade on 11/18/15.
//  Copyright © 2015 Morteza Hosseinizade. All rights reserved.
//

#import "UIViewController+Additional.h"
 
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


@end
