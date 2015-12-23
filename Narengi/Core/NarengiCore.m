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
    [request setTimeoutInterval:25];
    
    
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

-(NSArray *)parsAroudPlacesWith:(NSArray *)objects andwithType:(NSString *)type andIsDetail:(BOOL)isDetail{

    NSMutableArray *muTmpArr = [[NSMutableArray alloc] init];
    [objects enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        AroundPlaceObject *aroundPlObj = [[AroundPlaceObject alloc] init];
        
        NSDictionary *dict;
        NSString *typeStr;
        NSString *urlStr;
        
        if (type != nil) {
            typeStr = type;
            dict = obj;
            dict = [obj objectForKey:@"URL"];
        }
        else{
            
           dict    = [obj objectForKey:@"Data"];
           typeStr = [obj objectForKey:@"Type"];
           urlStr  = [[obj objectForKey:@"Data"] objectForKey:@"URL"];
            
        }

        
        if ([typeStr isEqualToString:@"House"]) {
            
            HouseObject *houseObj  = [[HouseObject alloc] init];
            
            houseObj.cityName       = [dict objectForKey:@"CityName"];
            houseObj.name           = [dict objectForKey:@"Name"];
            houseObj.cost           = [dict objectForKey:@"Cost"];
            houseObj.imageUrls      = [self parsImageArray:[dict objectForKey:@"Images"]];
            houseObj.rate           = [dict objectForKey:@"Rating"];
            houseObj.roundedRate    = [self roundRate:houseObj.rate];
            
            houseObj.summary        = [dict objectForKey:@"Summary"];
            houseObj.featureSummray = [dict objectForKey:@"FeatureSummray"];
            houseObj.url            = [dict objectForKey:@"URL"];
            houseObj.host = [self parsHost:[dict objectForKey:@"Host"]];
            
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
            cityObj.summary        = [dict objectForKey:@"Summary"];
            
            if (isDetail) {
                
                cityObj.houses      = [self parsAroudPlacesWith:[dict objectForKey:@"Houses"] andwithType:@"House" andIsDetail:NO];
                cityObj.attractions = [self parsAroudPlacesWith:[dict objectForKey:@"attraction"] andwithType:@"Attraction" andIsDetail:NO];
            }
            
            aroundPlObj.cityObject = cityObj;
        }
        
        aroundPlObj.type   = typeStr;
        aroundPlObj.urlStr = urlStr;
        
        [muTmpArr addObject:aroundPlObj];
        
    }];
    
    return [muTmpArr copy];
}

-(NSArray *)parsSuggestions:(NSDictionary *)dict{

    NSMutableArray *suggestarr = [[NSMutableArray alloc] init];
    [suggestarr addObject:[self parsAroudPlacesWith:[dict objectForKey:@"house"] andwithType:@"House" andIsDetail:NO]];
    [suggestarr addObject:[self parsAroudPlacesWith:[dict objectForKey:@"city"] andwithType:@"City" andIsDetail:NO]];
    [suggestarr addObject:[self parsAroudPlacesWith:[dict objectForKey:@"attraction"] andwithType:@"Attraction" andIsDetail:NO]];
    
    return [suggestarr copy];
    
}
-(HostObject *)parsHost:(NSDictionary *)dict{

    HostObject *hostObj = [[HostObject alloc] init];
    
    hostObj.imageUrl    = [NSURL URLWithString:[dict objectForKey:@"ImageUrl"]];
    hostObj.displayName = [dict objectForKey:@"DisplayName"];
    
    return hostObj;
}
-(NSArray *)parsImageArray:(NSArray *)images{

    NSMutableArray *muArr = [[NSMutableArray alloc] init];
    [images enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [muArr addObject:[NSURL URLWithString:obj]];
    }];
    
    return [muArr copy];
}


-(float)roundRate:(NSString *)valueStr {
    
    float value = [valueStr floatValue]/20;
    const float roundingValue = 0.5;
    int mulitpler = floor(value / roundingValue);
    
    return mulitpler * roundingValue;
    
}



@end
