//
//  NarengiCore.m
//  Narengi
//
//  Created by Morteza Hosseinizade on 11/18/15.
//  Copyright © 2015 Morteza Hosseinizade. All rights reserved.
//

#import "NarengiCore.h"
NarengiCore *sharedInstance;

@implementation NarengiCore


+ (NarengiCore*)sharedInstance
{
    if(sharedInstance == nil)
    {
        sharedInstance = [[NarengiCore alloc] init];
    }
    return sharedInstance;
    
}

#pragma mark - Server

-(ServerResponse *)sendRequestWithMethod:(NSString *)method andWithParametrs:(NSArray *)params andWithBody:(id)bodyDict{

    ServerResponse *serverRes;
    
    NSString *urlString = [NSString stringWithFormat:@"%@",BASEURL];
    
    NSLog(@"URL:%@",urlString );
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:method];
    
    
    NSData *bodyData = [NSKeyedArchiver archivedDataWithRootObject:bodyDict];

    [request setHTTPBody:[[[NSString alloc]initWithData:bodyData encoding:NSUTF8StringEncoding] dataUsingEncoding:NSUTF8StringEncoding]];
   // [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSError *error = nil;
    NSHTTPURLResponse* response;
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    if (!error) {
        
        if (response.statusCode == 200 ) {
            
            serverRes.hasErro = NO;
            serverRes.backDataDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil ];
        
        }
        else
        {
            serverRes.hasErro = YES;
        }
        
    }
    else
    {
        serverRes.hasErro = YES;
    }
    return serverRes;
    
}

@end
