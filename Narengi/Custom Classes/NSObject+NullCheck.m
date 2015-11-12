//
//  NSObject+NullCheck.m
//  Rahavard Novin
//
//  Created by Morteza hoseinizade on 5/2/13.
//  Copyright (c) 2013 Morteza Hoseini. All rights reserved.
//

#import "NSObject+NullCheck.h"

@implementation NSObject (NullCheck)
- (id) checkNull
{
    if(self != [NSNull null])
        return self;
    else
        return nil;
}
@end
