//
//  XXReply.m
//  Lecture
//
//  Created by 陈旭 on 16/1/28.
//  Copyright © 2016年 陈旭. All rights reserved.
//

#import "XXReply.h"

@implementation XXReply
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"ID" : @"id"};
}

- (NSString *)buildCommentText{
    return [NSString stringWithFormat:@"%@: %@", self.nickName, self.content];
}
@end
