//
//  UserObject.h
//  Narengi
//
//  Created by Morteza Hosseinizade on 11/18/15.
//  Copyright © 2015 Morteza Hosseinizade. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VerificationObject.h"

@interface UserObject : NSObject

@property (nonatomic) NSString  *fisrtName;
@property (nonatomic) NSString  *ID;
@property (nonatomic) NSString  *uID;
@property (nonatomic) NSString  *lastName;
@property (nonatomic) NSString  *fullName;
@property (nonatomic) NSString  *birthDate;
@property (nonatomic) NSInteger completePercent;
@property (nonatomic) NSString  *token;
@property (nonatomic) NSString  *gender;
@property (nonatomic) NSString  *bio;
@property (nonatomic) NSString  *sinceStr;
@property (nonatomic) NSString  *city;
@property (nonatomic) NSString  *province;

@property (nonatomic) NSString  *cellNumber;
@property (nonatomic) NSString  *email;
@property (nonatomic) NSURL     *avatarUrl;

@property (nonatomic) VerificationObject   *emailVerification;
@property (nonatomic) VerificationObject   *phoneVerification;
@property (nonatomic) VerificationObject   *idCardVerification;

@end
