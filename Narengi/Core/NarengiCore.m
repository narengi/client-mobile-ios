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
    
    

   // request.HTTPShouldHandleCookies = NO;

    
    
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
    
    NSString *escapedPath = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSLog(@"URL:%@",urlString );


    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:escapedPath]];
    [request setHTTPMethod:method];
    [request setTimeoutInterval:30];
    
    

    
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
            
            NSLog(@"BackData: %@",[NSJSONSerialization JSONObjectWithData:data options:0 error:nil ]);
            serverRes.hasErro = NO;
            serverRes.backData = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil ];
            serverRes.totalCount = [[[response.allHeaderFields objectForKey:@"X-Total-Count"] checkNull] integerValue];
            serverRes.link = [response.allHeaderFields objectForKey:@"Link"];
        
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
        
        
        NSDictionary *dict = [obj objectForKey:@"Data"];
        NSString *typeStr  = [obj objectForKey:@"Type"];
        
        if ([typeStr isEqualToString:@"House"]) {
            
            HouseObject *houseObj  = [[HouseObject alloc] init];
            
            houseObj.cityName  = [dict objectForKey:@"CityName"];
            houseObj.name      = [dict objectForKey:@"Name"];
            houseObj.cost      = [dict objectForKey:@"Cost"];
            houseObj.imageUrls = [self parsImageArray:[dict objectForKey:@"Images"]];
            houseObj.rate      = [dict objectForKey:@"Rating"];
            houseObj.summary   = [dict objectForKey:@"Summary"];
            houseObj.url       = [dict objectForKey:@"URL"];
            
            aroundPlObj.houseObject = houseObj;
            
            
        }
        else if ([typeStr isEqualToString:@"Attraction"]) {
            
            AttractionObject *attractionObj = [[AttractionObject alloc] init];
            
            attractionObj.name             = [dict objectForKey:@"Name"];
            attractionObj.imageUrls        = [self parsImageArray:[dict objectForKey:@"Images"]];
            attractionObj.aroundHousesText = [dict objectForKey:@"AroundHousesText"];
            attractionObj.cityName         = [dict objectForKey:@"CityName"];
            attractionObj.url              = [dict objectForKey:@"URL"];
            
            aroundPlObj.attractionObject = attractionObj;
            
        }
        else if ([typeStr isEqualToString:@"City"]) {
            
            CityObject *cityObj = [[CityObject alloc] init];
            
            cityObj.name           = [dict objectForKey:@"Name"];
            cityObj.houseCountText = [dict objectForKey:@"HouseCountText"];
            cityObj.houseCount     = [dict objectForKey:@"HouseCount"];
            cityObj.imageUrls      = [self parsImageArray:[dict objectForKey:@"Images"]];
            cityObj.url            = [dict objectForKey:@"URL"];
            
            aroundPlObj.cityObject = cityObj;
        }
        
        aroundPlObj.type = [obj objectForKey:@"Type"];
        
        [muTmpArr addObject:aroundPlObj];
        
    }];
    
    return [muTmpArr copy];
}

-(NSArray *)parsImageArray:(NSArray *)images{

    NSMutableArray *muArr = [[NSMutableArray alloc] init];
    [images enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [muArr addObject:[NSURL URLWithString:obj]];
    }];
    
    return [muArr copy];
}

@end
