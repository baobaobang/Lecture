//
//  XXExpert.h
//  Lecture
//
//  Created by 陈旭 on 16/1/15.
//  Copyright © 2016年 陈旭. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XXExpert : NSObject
/** 专家头像 */
@property (nonatomic, copy) NSString *icon;
/** 专家姓名 */
@property (nonatomic, copy) NSString *name;
/** 专家等级 */
@property (nonatomic, copy) NSString *level;
/** 专家科室 */
@property (nonatomic, copy) NSString *department;
/** 专家医院 */
@property (nonatomic, copy) NSString *hospital;
/** 专家简介 */
@property (nonatomic, copy) NSString *profile;
@end
