//
//  AttractionObject.h
//  Narengi
//
//  Created by Morteza Hosseinizade on 11/20/15.
//  Copyright © 2015 Morteza Hosseinizade. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AttractionObject : NSObject


@property (nonatomic) NSString       *name;
@property (nonatomic) NSString       *cityName;
@property (nonatomic) NSArray        *imageUrls;
@property (nonatomic) GeoPointObject *geoObj;
@property (nonatomic) NSString       *aroundHousesText;
@property (nonatomic) NSArray        *url;
@property (nonatomic) NSArray        *housesArr;

@property (nonatomic) NSString       *housesUrl;

@end
