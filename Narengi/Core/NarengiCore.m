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

-(ServerResponse *)sendRequestWithMethod:(NSString *)method andWithService:(NSString *)service andWithParametrs:(NSArray *)params andWithBody:(id)body{


    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",BASEURL,service];
    
    NSLog(@"URL:%@",urlString );
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:method];
    
    
    if (params != nil) {
        
        __block NSString *paramsStr = @"?";
        [params enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            paramsStr = [paramsStr stringByAppendingString:obj];
            if (idx < (params.count -1)) {
                paramsStr = [paramsStr stringByAppendingString:@"&"];
            }
            
            
        }];
        
        urlString = [urlString stringByAppendingString:paramsStr];
    }
    
    if (body != nil) {
        
        NSData *bodyData = [NSKeyedArchiver archivedDataWithRootObject:body];
        
        [request setHTTPBody:[[[NSString alloc]initWithData:bodyData encoding:NSUTF8StringEncoding] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    
    NSError *error = nil;
    NSHTTPURLResponse* response;
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    ServerResponse *serverRes = [[ServerResponse alloc] init];
    if (!error) {
        
        if (response.statusCode == 200 ) {
            
            serverRes.hasErro = NO;
            serverRes.backData = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil ];
            serverRes.totalCount = [[[response.allHeaderFields objectForKey:@"X-Total-Count"] checkNull] integerValue];
            serverRes.link = [response.allHeaderFields objectForKey:@":Link"];
        
        }
        else
        {
            serverRes.hasErro = YES;
            serverRes.backData = nil;
        }
        
    }
    else
    {
        serverRes.hasErro = YES;
        serverRes.backData = nil;
    }
    return serverRes;
    
}

-(NSArray *)parsAroudPlacesWith:(NSArray *)objects{

    NSMutableArray *muTmpArr = [[NSMutableArray alloc] init];
    [objects enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        AroundPlaceObject *aroundPlObj = [[AroundPlaceObject alloc] init];
        
        aroundPlObj.title     = [[obj objectForKey:@"Title"] checkNull];
        aroundPlObj.type      = [[obj objectForKey:@"Type"] checkNull];
        aroundPlObj.url       = [[obj objectForKey:@"Url"] checkNull];
        
        NSMutableArray *muArr = [[NSMutableArray alloc] init];
        [[[obj objectForKey:@"ImageUrls"] checkNull] enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [muArr addObject:[NSURL URLWithString:obj]];
        }];
        aroundPlObj.imageUrls = [muArr copy];
        
        [muTmpArr addObject:aroundPlObj];
        
    }];
    
    return [muTmpArr copy];
}

@end
