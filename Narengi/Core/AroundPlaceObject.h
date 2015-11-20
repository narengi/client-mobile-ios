//
//  AroundPlaceObject.h
//  Narengi
//
//  Created by Morteza Hosseinizade on 11/18/15.
//  Copyright © 2015 Morteza Hosseinizade. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AttractionObject.h"
#import "CityObject.h"
#import "HouseObject.h"

@interface AroundPlaceObject : NSObject

@property (nonatomic) CityObject       *cityObject;
@property (nonatomic) AttractionObject *attractionObject;
@property (nonatomic) HouseObject      *houseObject;
@property (nonatomic) NSString         *type;



@end
