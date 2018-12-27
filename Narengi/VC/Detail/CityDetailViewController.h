//
//  CityDetailViewController.h
//  Narengi
//
//  Created by Morteza Hosseinizade on 12/10/15.
//  Copyright © 2015 Morteza Hosseinizade. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HWViewPager.h"

@interface CityDetailViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDataSource,UIGestureRecognizerDelegate>


@property (nonatomic,strong) NSURL *url;

@end
