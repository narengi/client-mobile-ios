//
//  UserObject.h
//  Narengi
//
//  Created by Morteza Hosseinizade on 11/18/15.
//  Copyright © 2015 Morteza Hosseinizade. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserObject : NSObject

@property (nonatomic) NSString  *fisrtName;
@property (nonatomic) NSString  *lastName;
@property (nonatomic) NSDate  *birthDate;
@property (nonatomic) NSInteger completePercent;
@property (nonatomic) NSString  *token;

@property (nonatomic) NSString  *cellNumber;
@property (nonatomic) NSString  *email;
@property (nonatomic) NSURL     *avatarUrl;

@end
