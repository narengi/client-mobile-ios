//
//  CityObject.h
//  Narengi
//
//  Created by Morteza Hosseinizade on 11/20/15.
//  Copyright © 2015 Morteza Hosseinizade. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CityObject : NSObject


@property (nonatomic) NSString       *name;
@property (nonatomic) NSString       *houseCountText;
@property (nonatomic) NSArray        *imageUrls;
@property (nonatomic) GeoPointObject *geoObj;
@property (nonatomic) NSNumber       *houseCount;
@property (nonatomic) NSArray        *url;
@property (nonatomic) NSString       *summary;

@property (nonatomic) NSArray        *houses;
@property (nonatomic) NSArray        *attractions;

@end
