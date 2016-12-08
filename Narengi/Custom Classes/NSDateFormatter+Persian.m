//
//  NSDateFormatter+Persian.m
//  Rahavard Novin
//
//  Created by Morteza hoseinizade on 6/21/13.
//  Copyright (c) 2013 Morteza Hoseini. All rights reserved.
//

#import "NSDateFormatter+Persian.h"

@implementation NSDateFormatter (Persian)

-(NSDateFormatter *)change{
    
    NSCalendar *persCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierPersian];
    NSDateFormatter* dtFormatter = [[NSDateFormatter alloc] init];
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"fa_IR"];
    [dtFormatter setLocale:usLocale];
    [dtFormatter setCalendar:persCalendar];

    return dtFormatter;
}


-(NSDateFormatter *)changeForPeriods{
    
    NSCalendar *persCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierPersian];
    NSDateFormatter* dtFormatter = [[NSDateFormatter alloc] init];
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"fa_IR"];
    [dtFormatter setLocale:usLocale];
    [dtFormatter setCalendar:persCalendar];
    [dtFormatter setDateFormat:@"yyyy-MM-dd"];
    
    return dtFormatter;
}
-(NSDateFormatter *)changetoShortFormmat{
    
    NSCalendar *persCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierPersian];
    NSDateFormatter* dtFormatter = [[NSDateFormatter alloc] init];
    NSLocale *faLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"fa_IR"];
    [dtFormatter setLocale:faLocale];
    [dtFormatter setCalendar:persCalendar];
    [dtFormatter setDateStyle:NSDateFormatterMediumStyle];
    return dtFormatter;
}

-(NSDateFormatter *)changetoShortFormatWitoutYear{
    
    NSCalendar *persCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierPersian];
    NSDateFormatter* dtFormatter = [[NSDateFormatter alloc] init];
    NSLocale *faLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"fa_IR"];
    [dtFormatter setLocale:faLocale];
    [dtFormatter setCalendar:persCalendar];
    [dtFormatter setDateFormat:@"yyyy-MM-dd"];
    return dtFormatter;
}

@end
