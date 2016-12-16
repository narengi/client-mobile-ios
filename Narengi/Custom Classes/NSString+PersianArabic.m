//
//  NSString+PersianArabic.m
//  TV90
//
//  Created by Morteza Hoseinizade on 10/9/16.
//  Copyright © 2016 Baran-Mac. All rights reserved.
//

#import "NSString+PersianArabic.h"

@implementation NSString (PersianArabic)


-(NSString *)fixPersianArabaicnumberString{
    
    
    NSString *temStr = self;
    temStr = [[temStr componentsSeparatedByCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@"۰"]] componentsJoinedByString: @"0"];
    temStr = [[temStr componentsSeparatedByCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@"۱"]] componentsJoinedByString: @"1"];
    temStr = [[temStr componentsSeparatedByCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@"۲"]] componentsJoinedByString: @"2"];
    temStr = [[temStr componentsSeparatedByCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@"۳"]] componentsJoinedByString: @"3"];
    temStr = [[temStr componentsSeparatedByCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@"۴"]] componentsJoinedByString: @"4"];
    temStr = [[temStr componentsSeparatedByCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@"۵"]] componentsJoinedByString: @"5"];
    temStr = [[temStr componentsSeparatedByCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@"۶"]] componentsJoinedByString: @"6"];
    temStr = [[temStr componentsSeparatedByCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@"۷"]] componentsJoinedByString: @"7"];
    temStr = [[temStr componentsSeparatedByCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@"۸"]] componentsJoinedByString: @"8"];
    temStr = [[temStr componentsSeparatedByCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@"۹"]] componentsJoinedByString: @"9"];
    temStr = [[temStr componentsSeparatedByCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@"١"]] componentsJoinedByString: @"1"];
    temStr = [[temStr componentsSeparatedByCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@"٢"]] componentsJoinedByString: @"2"];
    temStr = [[temStr componentsSeparatedByCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@"٣"]] componentsJoinedByString: @"3"];
    temStr = [[temStr componentsSeparatedByCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@"٤"]] componentsJoinedByString: @"4"];
    temStr = [[temStr componentsSeparatedByCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@"٥"]] componentsJoinedByString: @"5"];
    temStr = [[temStr componentsSeparatedByCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@"٦"]] componentsJoinedByString: @"6"];
    temStr = [[temStr componentsSeparatedByCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@"٧"]] componentsJoinedByString: @"7"];
    temStr = [[temStr componentsSeparatedByCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@"٨"]] componentsJoinedByString: @"8"];
    temStr = [[temStr componentsSeparatedByCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@"٩"]] componentsJoinedByString: @"9"];
    temStr = [[temStr componentsSeparatedByCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@"٠"]] componentsJoinedByString: @"0"];
    
    return temStr;
    
}

@end
