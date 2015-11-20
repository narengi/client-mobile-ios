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
@property (nonatomic) NSArray        *imageUrls;
@property (nonatomic) GeoPointObject *geoObj;
@property (nonatomic) NSArray        *aroundHouses;
@property (nonatomic) NSArray        *url;

@end
