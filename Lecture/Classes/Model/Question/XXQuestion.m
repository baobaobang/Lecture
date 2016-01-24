//
//  XXQuestion.m
//  Lecture
//
//  Created by 陈旭 on 16/1/11.
//  Copyright © 2016年 陈旭. All rights reserved.
//

#import "XXQuestion.h"
#import <MJExtension.h>
#import "XXQuestionPhoto.h"

@implementation XXQuestion

+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"pic_urls" : [XXQuestionPhoto class], @"digUsers" : [XXUser class]};
}


//// 当前用户是否点赞过
//- (BOOL)isCurrentUserLike{
//    return [self.digUsers containsObject:[XXUser currentUser]];
//}

@end
