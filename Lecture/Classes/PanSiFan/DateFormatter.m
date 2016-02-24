//
//  DateFormatter.m
//  Lecture
//
//  Created by mortal on 16/2/14.
//  Copyright © 2016年 陈旭. All rights reserved.
//

#import "DateFormatter.h"

@implementation DateFormatter

+ (NSString *)dateStringFromString:(NSString *)str{
    NSDateFormatter*dft = [[NSDateFormatter alloc]init];//格式化
    [dft setDateFormat:@"yyyy-MM-dd'T'hh:mm:ss.SSS'Z'"];
    [dft setTimeZone:[NSTimeZone systemTimeZone]];
    [dft setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"]];
    NSDate *date = [dft dateFromString:str];
    
    return [date description];
    
}


+ (NSString *)formatDate:(NSDate *)date pattern:(NSString *)pattern{
    NSDateFormatter*dft = [[NSDateFormatter alloc]init];//格式化
    [dft setDateFormat:pattern];
    [dft setTimeZone:[NSTimeZone systemTimeZone]];
    [dft setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"]];
    return [dft stringFromDate:date];
}
@end
