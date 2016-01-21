//
//  UserObject.h
//  Narengi
//
//  Created by Morteza Hosseinizade on 11/18/15.
//  Copyright © 2015 Morteza Hosseinizade. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserObject : NSObject

@property (nonatomic) NSString *ID;
@property (nonatomic) NSString *displayName;
@property (nonatomic) NSString *cellNumber;
@property (nonatomic) NSString *Email;
@property (nonatomic) NSString *hostURL;


//detail
@property (nonatomic) NSString *locationText;
@property (nonatomic) NSString *career;
@property (nonatomic) NSString *memberFrom;
@property (nonatomic) NSString *descriptionStr;
@property (nonatomic) NSArray  *commentsArr;
@property (nonatomic) NSArray  *houseArr;



@end
