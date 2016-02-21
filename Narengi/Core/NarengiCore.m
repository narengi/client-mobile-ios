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

-(ServerResponse *)sendRequestWithMethod:(NSString *)method andWithService:(NSString *)service andWithParametrs:(NSArray *)params andWithBody:(id)body andIsFullPath:(BOOL) fullPath{


    
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
    
    if (fullPath) {
        escapedPath = service ;
    }

    NSLog(@"URL:%@",escapedPath );


    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:escapedPath]];
    [request setHTTPMethod:method];
   // [request setTimeoutInterval:25];
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"mobile" forHTTPHeaderField:@"src"];
    
    NSString *token  = [[NSUserDefaults standardUserDefaults] objectForKey:@"fuckingLoginedOrNOT"];
    
    if (token != nil )
        [request addValue:[self makeAuthurizationValue] forHTTPHeaderField:@"Authorization"];


    
    if (body != nil)
        [request setHTTPBody:body];
    
    
    
    NSError *error = nil;
    NSHTTPURLResponse* response;
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    ServerResponse *serverRes = [[ServerResponse alloc] init];
    if (!error) {
        
        if (response.statusCode == 200 || response.statusCode == 201  || response.statusCode == 204) {
            
            NSLog(@"BackData: %@",[NSJSONSerialization JSONObjectWithData:data options:0 error:nil ]);
            serverRes.hasErro = NO;
            serverRes.backData = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil ];
            serverRes.totalCount = [[[response.allHeaderFields objectForKey:@"X-Total-Count"] checkNull] integerValue];
            serverRes.link = [response.allHeaderFields objectForKey:@"Link"];
        
        }
        else if(response.statusCode == 401)
        {
            serverRes.hasErro = YES;
            serverRes.backData = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil ];
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
        
        if (error.code  == -1012) {
         
            id backData = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil ];
            
            if (backData != nil)
                serverRes.backData = backData;
            
            else
                serverRes.backData  = nil;
            
        }
        else{
            serverRes.backData = nil;
        }
        
    }
    return serverRes;
    
}


//Upload profile Image
-(void )sendServerRequestProfileImageWithImage:(NSData *)imageData{
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@user-profiles/picture",BASEURL]]];
    
    
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setHTTPShouldHandleCookies:NO];
    [request setTimeoutInterval:60];
    [request setHTTPMethod:@"POST"];
    
    NSString *boundary = @"unique-consistent-string";
    
    // set Content-Type in HTTP header
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    NSMutableData* body = [NSMutableData data];
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"picture\"; filename=\"%@\"\r\n", @"aa"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Type: %@\r\n\r\n", @"image/jpeg"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:imageData];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:body];

    [request addValue:@"mobile" forHTTPHeaderField:@"src"];
    [request addValue:[self makeAuthurizationValue] forHTTPHeaderField:@"Authorization"];
    
    NSError *error = nil;
    NSHTTPURLResponse* response;
    
    
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    if (data == nil)
    {
        
        
    }
    else
    {
        NSDictionary *backDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil ];
        
        if (response.statusCode == 200) {
            
            if (backDict != nil) {
            }
        }
        
    }
    
}

-(NSString *)makeAuthurizationValue{

    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"fuckingLoginedOrNOT"];
    NSString *user  = [[NSUserDefaults standardUserDefaults] objectForKey:@"loginedUser"];
    
    NSDictionary* authenticateDict ;
    authenticateDict = @{@"username": user,@"token": token};
    
    NSData *bodyData = [NSJSONSerialization dataWithJSONObject:authenticateDict options:0 error:nil];
    NSString *result = [[NSString alloc] initWithData:bodyData encoding:NSUTF8StringEncoding];
    
    result  =[result stringByReplacingOccurrencesOfString:@"{" withString:@""] ;
    result  =[result stringByReplacingOccurrencesOfString:@"}" withString:@""] ;
    
    return result;

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
            urlStr = [obj objectForKey:@"URL"];
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
            houseObj.ID             = [[dict objectForKey:@"id"] checkNull];
            houseObj.imageUrls      = [self parsImageArray:[dict objectForKey:@"Images"]];
            houseObj.rate           = [dict objectForKey:@"Rating"];
            houseObj.roundedRate    = [self roundRate:houseObj.rate];
            houseObj.geoObj         = [self parsLocation:[dict objectForKey:@"Position"]];
            
            houseObj.summary        = [dict objectForKey:@"Summary"];
            houseObj.featureSummray = [dict objectForKey:@"FeatureSummray"];
            houseObj.url            = [dict objectForKey:@"URL"];
            houseObj.host = [self parsHost:[dict objectForKey:@"Host"] isDetail:NO];
            
            aroundPlObj.houseObject = houseObj;
            
            if (isDetail) {
                houseObj.commentsArr     = [self parsComments:[dict objectForKey:@"Reviews"]];
                houseObj.facilityArr     = [self parsFacilities:[dict objectForKey:@"FeatureList"]];
                houseObj.shownFacilities = [self parsShownFacilities:houseObj.facilityArr];
                
                houseObj.type         = [dict objectForKey:@"type"];
                houseObj.bedroomCount = [[[dict objectForKey:@"bedroomCount"] checkNull] stringValue];
                houseObj.guestCount   = [[[dict objectForKey:@"guestCount"] checkNull] stringValue];
                houseObj.bedCount     = [[[dict objectForKey:@"bedCount"] checkNull ] stringValue];
                houseObj.reviewCount  = [[[dict objectForKey:@"reviewsCount"] checkNull] stringValue];
                
                if ([[houseObj.shownFacilities lastObject] isKindOfClass:[NSString class]]) {
                    
                    houseObj.canShowMoreFacility = YES;
                }
                else
                    houseObj.canShowMoreFacility = NO;
                
            }
            
        }
        else if ([typeStr isEqualToString:@"Attraction"]) {
            
            AttractionObject *attractionObj = [[AttractionObject alloc] init];
            
            attractionObj.name             = [dict objectForKey:@"Name"];
            attractionObj.imageUrls        = [self parsImageArray:[dict objectForKey:@"Images"]];
            attractionObj.aroundHousesText = [dict objectForKey:@"AroundHousesText"];
            attractionObj.cityName         = [dict objectForKey:@"CityName"];
            attractionObj.url              = [dict objectForKey:@"URL"];
            
            if (isDetail) {
                
                attractionObj.housesArr      = [self parsAroudPlacesWith:[dict objectForKey:@"Houses"] andwithType:@"House" andIsDetail:NO];
                
                attractionObj.housesUrl      = [dict objectForKey:@"HousesUrl"];
            }
            
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
                
                cityObj.attractions = [self parsAroudPlacesWith:[dict objectForKey:@"Attraction"] andwithType:@"Attraction" andIsDetail:NO];
                
                cityObj.housesUrl      = [dict objectForKey:@"HousesUrl"];
                cityObj.attractionsUrl = [dict objectForKey:@"AttractionsUrl"];

            }
            
            aroundPlObj.cityObject = cityObj;
        }
        
        aroundPlObj.type   = typeStr;
        aroundPlObj.urlStr = urlStr;
        
        [muTmpArr addObject:aroundPlObj];
        
    }];
    
    return [muTmpArr copy];
}

-(GeoPointObject *)parsLocation:(NSDictionary *)position{

    GeoPointObject *positionObj = [[GeoPointObject alloc] init];
    positionObj.lat = [[position objectForKey:@"lat"] doubleValue];
    positionObj.lng = [[position objectForKey:@"lng"] doubleValue];
    
    return positionObj;
}

-(NSArray *)parsComments:(NSArray *)comments{

    NSMutableArray *muArr = [[NSMutableArray alloc] init];
    [comments enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        CommentObject *commentObj = [[CommentObject alloc] init];
        
        NSAttributedString * nameAtStr = [[NSAttributedString alloc] initWithString:[[obj objectForKey:@"reviewer"] stringByAppendingString:@": "] attributes:@{NSForegroundColorAttributeName:RGB(0, 150, 50, 1)}];
        
        NSAttributedString * messageAtStr = [[NSAttributedString alloc] initWithString:[obj objectForKey:@"Message"]attributes:@{NSForegroundColorAttributeName:RGB(118, 118, 118, 1)}];
        
        NSMutableAttributedString *atText =
        [[NSMutableAttributedString alloc]
         initWithAttributedString: nameAtStr];
        
        [atText appendAttributedString:messageAtStr];

        commentObj.attributeStr = atText;
        commentObj.writerName   = [obj objectForKey:@"reviewer"];
        commentObj.message      = [obj objectForKey:@"Message"];
        commentObj.dateStr      = [obj objectForKey:@"date"];
        commentObj.imageUrl     = [NSURL URLWithString:[obj objectForKey:@"ImageUrl"] ];
        commentObj.rate         = [[obj objectForKey:@"rate"] stringValue];
        commentObj.roundedRate  = [self roundRate:commentObj.rate];

        [muArr addObject:commentObj];
        
    }];
    
    return muArr.copy;
}

-(NSArray *)parsFacilities:(NSArray*) facilities{

    NSMutableArray *muArr = [[NSMutableArray alloc] init];
    [facilities enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        FacilityObject *facilityObj = [[FacilityObject alloc] init];
        
        facilityObj.name      = [[obj objectForKey:@"name"] checkNull];
        facilityObj.type      = [[obj objectForKey:@"type"] checkNull];
        facilityObj.available = [[obj objectForKey:@"available"] boolValue];
        facilityObj.iconUrl   = [[NSURL URLWithString:[obj objectForKey:@"imageUrl"]] checkNull];
        
        if (facilityObj.available) {
        
            [muArr addObject:facilityObj];
        }
        
    }];
    
    return muArr.copy;
}
-(NSArray *)parsShownFacilities:(NSArray*) facilities{
    
    NSInteger capicity;
    
    if ([UIScreen mainScreen].bounds.size.width == 320)
        capicity = 4;
    
    else
        capicity = 5;
    
    if (facilities.count <= capicity){
        return facilities;
    }
    
    else{
        
        NSMutableArray *muArr = [[NSMutableArray alloc] init];
        NSArray *subRangeArr = [facilities subarrayWithRange:NSMakeRange(0, capicity-1)];
        [muArr addObjectsFromArray:subRangeArr];
        [muArr addObject:[NSString stringWithFormat:@"%ld +",facilities.count - capicity+ 1]];
        
        return [muArr copy];
    }
    
}

-(NSArray *)parsSuggestions:(NSDictionary *)dict{

    NSMutableArray *suggestarr = [[NSMutableArray alloc] init];
    [suggestarr addObject:[self parsAroudPlacesWith:[dict objectForKey:@"house"] andwithType:@"House" andIsDetail:NO]];
    [suggestarr addObject:[self parsAroudPlacesWith:[dict objectForKey:@"city"] andwithType:@"City" andIsDetail:NO]];
    [suggestarr addObject:[self parsAroudPlacesWith:[dict objectForKey:@"attraction"] andwithType:@"Attraction" andIsDetail:NO]];
    
    return [suggestarr copy];
    
}
-(HostObject *)parsHost:(NSDictionary *)dict isDetail:(BOOL)isDetail{

    HostObject *hostObj = [[HostObject alloc] init];
    
    hostObj.imageUrl    = [dict objectForKey:@"ImageUrl"];
    hostObj.displayName = [dict objectForKey:@"DisplayName"];
    hostObj.hostURL     = [dict objectForKey:@"HostURL"];
    
    if (isDetail) {
        
        hostObj.locationText   = [dict objectForKey:@"LocationText"];
        hostObj.career         = [dict objectForKey:@"Job"];
        hostObj.memberFrom     = [dict objectForKey:@"MemberFrom"];
        hostObj.descriptionStr = [dict objectForKey:@"Description"];
        hostObj.commentsArr    = [self parsComments:[dict objectForKey:@"reviews"] ];
        hostObj.houseArr       = [self parsAroudPlacesWith:[dict objectForKey:@"Houses"] andwithType:@"House" andIsDetail:NO];
        hostObj.descriptionStr = [dict objectForKey:@"Summary"];
        
    }
    
    return hostObj;
}


-(UserObject *)parsUserObject:(NSDictionary *)dict {
    
    UserObject *userObj = [[UserObject alloc] init];
    
    userObj.avatarUrl       = [NSURL URLWithString:[[dict objectForKey:@"ImageUrl"] checkNull]];
    userObj.fisrtName       = [[[dict objectForKey:@"profile"] checkNull] objectForKey:@"firstName"];
    userObj.lastName        = [[[dict objectForKey:@"profile"] checkNull] objectForKey:@"lastName"];
    userObj.email           = [dict objectForKey:@"email"];
    userObj.cellNumber      = [dict objectForKey:@"cellNumber"];
    userObj.completePercent = [[[dict objectForKey:@"status"] objectForKey:@"completed"] integerValue];
    userObj.token           = [[dict objectForKey:@"token"] objectForKey:@"token"];
    userObj.gender          = [[[dict objectForKey:@"profile"] checkNull] objectForKey:@"gender"];
    userObj.birthDate       = [[[[dict objectForKey:@"profile"] checkNull] objectForKey:@"birthDate"] checkNull];
    
    [[dict objectForKey:@"verification"] enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        VerificationObject *verificationObj = [self parsVerificationWithDict:obj];
        userObj.phoneVerification = [verificationObj.type isEqualToString:@"SMS"] ? verificationObj :nil
        ;
        userObj.emailVerification = [verificationObj.type isEqualToString:@"Email"] ? verificationObj :nil
        ;
    }];
    
    return userObj;
}
-(VerificationObject *)parsVerificationWithDict:(NSDictionary *)dict{

    VerificationObject *verificationObj = [[VerificationObject alloc] init];
    
    verificationObj.isVerified    = [[dict objectForKey:@"verified"] boolValue];
    verificationObj.type          = [dict objectForKey:@"verificationType"];
    verificationObj.code          = [dict objectForKey:@"code"];
    verificationObj.requestedDate = [dict objectForKey:@"requestDate"];
    
    return verificationObj;
    
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

#pragma mark - register

-(BOOL)checkLogin{

    NSString *str = [[NSUserDefaults standardUserDefaults]objectForKey:@"fuckingLoginedOrNOT"];
    
    if (str == nil)
        return YES;
    
    else
        return NO;
    
}



@end
