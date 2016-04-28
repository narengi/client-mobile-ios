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
#import "CommissionObjetc.h"

@interface HouseObject : NSObject

@property (nonatomic) NSString         *ID;
@property (nonatomic) GeoPointObject   *geoObj;
@property (nonatomic) NSString         *cityName;
@property (nonatomic) NSArray          *imageUrls;
@property (nonatomic) HostObject       *host;
@property (nonatomic) NSString         *cost;
@property (nonatomic) NSInteger        price;
@property (nonatomic) NSString         *rate;
@property (nonatomic) float            roundedRate;
@property (nonatomic) NSString         *summary;
@property (nonatomic) NSString         *url;
@property (nonatomic) NSString         *name;
@property (nonatomic) NSString         *featureSummray;

@property (nonatomic) NSArray          *exteraServices;
@property (nonatomic) NSArray          *commentsArr;
@property (nonatomic) NSArray          *facilityArr;
@property (nonatomic) NSArray          *shownFacilities;

@property (nonatomic) BOOL             canShowMoreFacility;


@property (nonatomic) NSString         *type;
@property (nonatomic) NSString         *bedroomCount;
@property (nonatomic) NSString         *guestCount;
@property (nonatomic) NSString         *bedCount;
@property (nonatomic) NSString         *reviewCount;
@property (nonatomic) CommissionObjetc *commissionObj;



@end
