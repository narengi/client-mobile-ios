//
//  CommentObject.h
//  Narengi
//
//  Created by Morteza Hosseinizade on 1/7/16.
//  Copyright © 2016 Morteza Hosseinizade. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentObject : NSObject


@property (nonatomic) NSAttributedString *attributeStr;
@property (nonatomic) NSString           *writerName;
@property (nonatomic) NSString           *message;
@property (nonatomic) NSString           *dateStr;
@property (nonatomic) NSURL              *imageUrl;
@property (nonatomic) NSString           *rate;
@property (nonatomic) float              roundedRate;

@end
