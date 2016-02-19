//
//  NarengiCore.h
//  Narengi
//
//  Created by Morteza Hosseinizade on 11/18/15.
//  Copyright © 2015 Morteza Hosseinizade. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServerResponse.h"
#import "HostObject.h"
#import "UserObject.h"

@interface NarengiCore : NSObject


+ (NarengiCore *)sharedInstance;
-(ServerResponse *)sendRequestWithMethod:(NSString *)method andWithService:(NSString *)service andWithParametrs:(NSArray *)params andWithBody:(id)body andIsFullPath:(BOOL) fullPath;

-(NSArray *)parsAroudPlacesWith:(NSArray *)objects andwithType:(NSString *)type andIsDetail:(BOOL)isDetail;
-(NSArray *)parsSuggestions:(NSDictionary *)dict;

-(NSArray *)parsComments:(NSArray *)comments;
-(HostObject *)parsHost:(NSDictionary *)dict isDetail:(BOOL)isDetail;
-(UserObject *)parsUserObject:(NSDictionary *)dict;


@end
