//
//  XXQuestion.h
//  Lecture
//
//  Created by 陈旭 on 16/1/11.
//  Copyright © 2016年 陈旭. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XXUser.h"

@interface XXQuestion : NSObject

/**	字符串型的问题ID*/
@property (nonatomic, copy) NSString *idstr;

/**	问题文字内容*/
@property (nonatomic, copy) NSString *text;

/**	用户信息*/
@property (nonatomic, strong) XXUser *user;

/**	创建时间*/
@property (nonatomic, copy) NSString *created_at;

/** 配图地址。多图时返回多图链接。无配图返回“[]” */
@property (nonatomic, strong) NSArray *pic_urls;

/**	分享数*/
@property (nonatomic, assign) NSUInteger shares_count;
/**	点赞数*/
@property (nonatomic, assign) NSUInteger attitudes_count;
/**	是否点赞*/
@property (nonatomic, assign) BOOL like;

- (NSComparisonResult)compareAttitudesCount:(XXQuestion *)other;
@end