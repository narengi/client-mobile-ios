//
//  ServerResponse.h
//  Narengi
//
//  Created by Morteza Hosseinizade on 11/18/15.
//  Copyright © 2015 Morteza Hosseinizade. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServerResponse : NSObject

@property (nonatomic) id        backData;
@property (nonatomic) BOOL      hasErro;
@property (nonatomic) NSString  *link;
@property (nonatomic) NSString  *message;
@property (nonatomic) NSInteger totalCount;


@end
