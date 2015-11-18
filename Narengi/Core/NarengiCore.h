//
//  NarengiCore.h
//  Narengi
//
//  Created by Morteza Hosseinizade on 11/18/15.
//  Copyright © 2015 Morteza Hosseinizade. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServerResponse.h"

@interface NarengiCore : NSObject


+ (NarengiCore *)sharedInstance;
-(ServerResponse *)sendRequestWithMethod:(NSString *)method andWithParametrs:(NSArray *)params andWithBody:(id)bodyDict;



@end
