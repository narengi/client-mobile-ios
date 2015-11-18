//
//  HouseObject.h
//  Narengi
//
//  Created by Morteza Hosseinizade on 11/18/15.
//  Copyright © 2015 Morteza Hosseinizade. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HostObject.h"
#import "GeoPointObject.h"

@interface HouseObject : NSObject

@property (nonatomic) NSString       *ID;
@property (nonatomic) GeoPointObject *geoObj;
@property (nonatomic) NSString       *address;
@property (nonatomic) NSString       *postalCode;
@property (nonatomic) NSArray        *phoneNumbers;
@property (nonatomic) NSString       *cityID;
@property (nonatomic) NSString       *cityName;
@property (nonatomic) NSArray        *imageUrls;
@property (nonatomic) HostObject     *host;

@end
