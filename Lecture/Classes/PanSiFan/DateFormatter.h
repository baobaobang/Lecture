//
//  DateFormatter.h
//  Lecture
//
//  Created by mortal on 16/2/14.
//  Copyright © 2016年 陈旭. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateFormatter : NSObject

+ (NSString *)dateStringFromString:(NSString *)str;

+ (NSString *)formatDate:(NSDate *)date pattern:(NSString *)pattern;

@end
