//
//  UIViewController+Additional.m
//  Narengi
//
//  Created by Morteza Hosseinizade on 11/18/15.
//  Copyright © 2015 Morteza Hosseinizade. All rights reserved.
//

#import "UIViewController+Additional.h"
#import "JDStatusBarNotification.h"

@implementation UIViewController (Additional)


-(void)loading{
    
    [JDStatusBarNotification addStyleNamed:@"moStyle"
                                   prepare:^JDStatusBarStyle*(JDStatusBarStyle *style) {
                                       
                                       // main properties
                                      // style.barColor = RGB(72, 154, 175, 1);
                                       //style.textColor = [UIColor whiteColor];
                                       //style.font = [UIFont fontWithName:@"IRANSans" size:16.0f];;
                                       
                                       // advanced properties
                                       style.animationType = JDStatusBarAnimationTypeMove;
                                       
                                       
                                       return style;
                                   }];
    
    [JDStatusBarNotification showWithStatus:LANGUAGEKEY(@"LOADING") styleName : @"moStyle"];
    [JDStatusBarNotification showActivityIndicator:YES indicatorStyle:UIActivityIndicatorViewStyleWhite];
    
}

-(void)noConnection{
    
    
    [JDStatusBarNotification showWithStatus:LANGUAGEKEY(@"CHECKYOUINTERNET") dismissAfter:1 styleName:JDStatusBarStyleError];
    
}

-(void)successData{
    
    [JDStatusBarNotification dismissAfter:.1];
}

-(void)showToastwithString:(NSString *)text{
    
    [JDStatusBarNotification addStyleNamed:@"moStyle"
                                   prepare:^JDStatusBarStyle*(JDStatusBarStyle *style) {
                                       
                                       // main properties
                                      // style.barColor = RGB(72, 154, 175, 1);
                                       //style.textColor = [UIColor whiteColor];
                                       //style.font = [UIFont fontWithName:@"IRANSans" size:16.0f];;
                                       
                                       // advanced properties
                                       style.animationType = JDStatusBarAnimationTypeMove;
                                       
                                       
                                       return style;
                                   }];
    [JDStatusBarNotification showWithStatus:text dismissAfter:1.5 styleName:JDStatusBarStyleDefault];
}

-(void)serverError{
    
    [JDStatusBarNotification addStyleNamed:@"moStyle"
                                   prepare:^JDStatusBarStyle*(JDStatusBarStyle *style) {
                                       
                                       // main properties
                                      // style.barColor = RGB(72, 154, 175, 1);
                                       //style.textColor = [UIColor whiteColor];
                                       //style.font = [UIFont fontWithName:@"IRANSans" size:16.0f];;
                                       
                                       // advanced properties
                                       style.animationType = JDStatusBarAnimationTypeMove;
                                       
                                       
                                       return style;
                                   }];
    [JDStatusBarNotification showWithStatus:LANGUAGEKEY(@"SERVERERROR") dismissAfter:1 styleName:JDStatusBarStyleError];
    
    
}
-(void)dismissLoading{
    
    [JDStatusBarNotification dismissAfter:.1];
}

@end
