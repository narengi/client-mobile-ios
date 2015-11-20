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
@property (nonatomic) NSString       *cityName;
@property (nonatomic) NSArray        *imageUrls;
@property (nonatomic) HostObject     *host;
@property (nonatomic) NSString       *cost;
@property (nonatomic) NSString       *rate;
@property (nonatomic) NSString       *summary;
@property (nonatomic) NSString       *url;



@end
