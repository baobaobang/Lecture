//
//  XXQuestion.m
//  Lecture
//
//  Created by 陈旭 on 16/1/11.
//  Copyright © 2016年 陈旭. All rights reserved.
//

#import "XXQuestion.h"

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
@end
