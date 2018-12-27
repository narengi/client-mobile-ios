//
//  UIViewController+Utilities.m
//  Narengi
//
//  Created by Morteza Hosseinizade on 11/10/15.
//  Copyright © 2015 Morteza Hosseinizade. All rights reserved.
//

#import "UIViewController+Utilities.h"

@implementation UIViewController (Utilities)

-(void)registerCollectionCellWithName:(NSString *)nibName andWithId:(NSString *)identifier forCORT:(id)list
{
    
    UINib *cellWithImageNib = [UINib nibWithNibName:nibName bundle:nil];
    [list registerNib:cellWithImageNib forCellWithReuseIdentifier:identifier];
}


@end
