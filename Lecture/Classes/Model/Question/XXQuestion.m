//
//  XXQuestion.m
//  Lecture
//
//  Created by 陈旭 on 16/1/11.
//  Copyright © 2016年 陈旭. All rights reserved.
//

#import "XXQuestion.h"
#import "MJExtension.h"
#import "XXQuestionPhoto.h"
#import "XXReply.h"

@implementation XXQuestion

+ (NSDictionary *)mj_objectClassInArray
{
//    return @{@"images" : [XXQuestionPhoto class], @"replies" : [XXReply class]};
    return @{@"replies" : [XXReply class]};
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"ID" : @"id", @"attitudes_count" : @"likersCount", @"created_at" : @"createDate" };
}

// 截图字符串返回XXQuestionPhoto数组

- (NSArray *)photos{
    NSArray *array = [self.images componentsSeparatedByString:@","];
    NSMutableArray *arrayM = [NSMutableArray array];
    for (NSString *image in array) {
        XXQuestionPhoto *photo = [[XXQuestionPhoto alloc] init];
        photo.highQuality_pic = image;
        [arrayM addObject:photo];
    }
    return arrayM;
}

@end
