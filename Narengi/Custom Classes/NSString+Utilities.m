//
//  NSString+Utilities.m
//  Narengi
//
//  Created by Morteza Hosseinizade on 4/21/16.
//  Copyright © 2016 Morteza Hosseinizade. All rights reserved.
//

#import "NSString+Utilities.h"

@implementation NSString (Utilities)

-(NSString *)fixPersianString{
    
    NSCharacterSet *doNotWant = [NSCharacterSet characterSetWithCharactersInString:@"ك"];
    NSCharacterSet *doNotWant1 = [NSCharacterSet characterSetWithCharactersInString:@"ي"];
    NSString *temStr = self;
    temStr = [[temStr componentsSeparatedByCharactersInSet: doNotWant] componentsJoinedByString: @"ک"];
    temStr = [[temStr componentsSeparatedByCharactersInSet: doNotWant1] componentsJoinedByString: @"ی"];
    
    return temStr;
    
}

-(NSURL *)addImageBaseUrl{

    return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGEBASEURL,self]];
}


-(NSString *)addBaseUrl{
    
    return [NSString stringWithFormat:@"%@%@",IMAGEBASEURL,self];
}

@end
