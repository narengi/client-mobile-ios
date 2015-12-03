//
//  SearchViewController.h
//  Narengi
//
//  Created by Morteza Hosseinizade on 12/3/15.
//  Copyright © 2015 Morteza Hosseinizade. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchTableViewCell.h"

@interface SearchViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *searchViewContainer;


@end
