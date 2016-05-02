//
//  UIViewController+Additional.h
//  Narengi
//
//  Created by Morteza Hosseinizade on 11/18/15.
//  Copyright © 2015 Morteza Hosseinizade. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Additional)<UIGestureRecognizerDelegate>

-(void)changeRightIcontoMap;
-(void)changeLeftIcontoBack;
-(void)ChangeRightButtonToSkipCurrentStep;
-(void)goToIdCardVerification;
-(void)changeRightIcontoDismiss;
-(void)noConnection;
-(void)goTodetailWithUrl:(NSString *)urlStr andWithType:(NSString *)type;
-(NSURL*)fixUrl:(NSURL *)url withParametrs:(NSArray *)parametrs;
-(void)insertGradientToView:(UIView *)View;

-(void)goToRegister;
-(void)showErro:(NSString *)str;
-(void)goToRegisterORBookWithObject:(HouseObject *)houseObj;
-(void)registerCellWithName:(NSString *)name andWithIdentifier :(NSString *)identifier andTableView:(UITableView *)tableview;
-(void)changeRightIconToSkip;
-(void)gotoMapForHouseDetailwithGeo:(GeoPointObject *)geo;
-(void)gotoMapFromCityWithHouses:(NSArray *)houses andWithTitle:(NSString *)title;

@end
