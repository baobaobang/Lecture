//
//  XXQuestion.h
//  Lecture
//
//  Created by 陈旭 on 16/1/11.
//  Copyright © 2016年 陈旭. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XXQuestion : NSObject
/**	NSInteger	转发数*/
@property (nonatomic, assign) NSInteger retweets_count;
/**	NSInteger	评论数*/
@property (nonatomic, assign) NSInteger replys_count;
/**	NSInteger	表态数*/
@property (nonatomic, assign) NSInteger attitudes_count;
/**	BOOL    是否点赞*/
@property (nonatomic, assign) BOOL like;

@end