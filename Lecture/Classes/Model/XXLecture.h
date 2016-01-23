//
//  XXLecture.h
//  Lecture
//
//  Created by 陈旭 on 16/1/22.
//  Copyright © 2016年 陈旭. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XXLecture : NSObject
// 讲座id
@property (nonatomic, copy) NSString *idStr;
// 讲座介绍图片
@property (nonatomic, copy) NSString *profilePic;
// 讲座专家数组
@property (nonatomic, strong) NSArray *experts;
// 讲座开始时间
@property (nonatomic, strong) NSDate *beginTime;
// 讲座结束时间
@property (nonatomic, strong) NSDate *endTime;
// 讲座名字
@property (nonatomic, copy) NSString *name;
// 讲座所需积分
@property (nonatomic, assign) NSUInteger points;

@end
