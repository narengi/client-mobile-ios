//
//  GeoPointObject.m
//  Narengi
//
//  Created by Morteza Hosseinizade on 11/18/15.
//  Copyright © 2015 Morteza Hosseinizade. All rights reserved.
//

#import "GeoPointObject.h"

@implementation GeoPointObject

-(GeoPointObject *)initWith:(double)lat andWithLng:(double)lng{

    GeoPointObject *geo = [[GeoPointObject alloc] init];
    geo.lat = lat;
    geo.lng = lng;
    
    return geo;
}
@end
