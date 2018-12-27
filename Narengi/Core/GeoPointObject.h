//
//  GeoPointObject.h
//  Narengi
//
//  Created by Morteza Hosseinizade on 11/18/15.
//  Copyright © 2015 Morteza Hosseinizade. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GeoPointObject : NSObject

@property (nonatomic) double lat;
@property (nonatomic) double lng;

-(GeoPointObject *)initWith:(double)lat andWithLng:(double)lng;

@end
