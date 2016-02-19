//
//  VerificationObject.h
//  Narengi
//
//  Created by Morteza Hosseinizade on 2/12/16.
//  Copyright © 2016 Morteza Hosseinizade. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VerificationObject : NSObject

@property (nonatomic) NSString *code;
@property (nonatomic) NSString *type;
@property (nonatomic) NSString *requestedDate;
@property (nonatomic) BOOL     isVerified;


@end
