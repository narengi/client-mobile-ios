//
//  FacilityObject.h
//  Narengi
//
//  Created by Morteza Hosseinizade on 1/7/16.
//  Copyright © 2016 Morteza Hosseinizade. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FacilityObject : NSObject

@property (nonatomic) NSString *name;
@property (nonatomic) NSString *key;
@property (nonatomic) NSString *ID;
@property (nonatomic) BOOL     available;
@property (nonatomic) NSURL    *iconUrl;

@end
