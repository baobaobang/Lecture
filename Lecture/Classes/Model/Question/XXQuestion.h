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

/**	问题文字内容*/
@property (nonatomic, copy) NSString *text;

/**	创建者*/
@property (nonatomic, strong) XXUser *user;

/**	创建时间*/
@property (nonatomic, copy) NSString *created_at;

/** 配图地址。多图时返回多图链接。无配图返回“[]” */
@property (nonatomic, strong) NSArray *pic_urls;

/**	分享数*/
@property (nonatomic, assign) NSUInteger shares_count;
/**	评论数*/
@property (nonatomic, assign) NSInteger replys_count;
/**	赞过的人*/
//@property (nonatomic,assign) NSMutableArray* digUsers;
/**	点赞数*/
@property (nonatomic, assign) NSUInteger attitudes_count;
/**	自己是否点赞*/
@property (nonatomic, assign, getter=isLike) BOOL like;


// 当前用户是否点赞过
//- (BOOL)isCurrentUserLike;

@end