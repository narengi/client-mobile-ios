//
//  SelectCityViewController.h
//  Narengi
//
//  Created by Morteza Hosseinizade on 4/21/16.
//  Copyright © 2016 Morteza Hosseinizade. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectCityViewController : UIViewController


@property (nonatomic) BOOL isSelectCity;
@property (nonatomic,strong) NSString *selectedCity;
@property (nonatomic,strong) NSArray *cityArr;

@end
