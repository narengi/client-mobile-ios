//
//  HostObject.h
//  Narengi
//
//  Created by Morteza Hosseinizade on 11/18/15.
//  Copyright © 2015 Morteza Hosseinizade. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HostObject : NSObject

@property (nonatomic) NSString *displayName;
@property (nonatomic) NSURL *imageUrl;
@property (nonatomic) NSString *hostURL;
@property (nonatomic) NSString *ID;

//detail
@property (nonatomic) NSString *locationText;
@property (nonatomic) NSString *career;
@property (nonatomic) NSString *memberFrom;
@property (nonatomic) NSString *descriptionStr;
@property (nonatomic) NSArray  *commentsArr;
@property (nonatomic) NSArray  *houseArr;

@end
