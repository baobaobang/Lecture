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
- (NSComparisonResult)compareAttitudesCount:(XXQuestion *)other{
    
    if (self.attitudes_count > other.attitudes_count) {
        return NSOrderedAscending;
    }else if(self.attitudes_count < other.attitudes_count){
        return NSOrderedDescending;
    }else{
        return NSOrderedSame;
    }
}

+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"pic_urls" : [XXQuestionPhoto class]};
}
@end
