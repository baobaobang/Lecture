//
//  XXQuestion.h
//  Lecture
//
//  Created by 陈旭 on 16/1/11.
//  Copyright © 2016年 陈旭. All rights reserved.
//

#import "XXBaseModel.h"

@interface XXQuestion : XXBaseModel
/**	问题id*/
@property (nonatomic, copy) NSString *ID;
/**	讲座id*/
@property (nonatomic, copy) NSString *lectureId;

/**	问题的文字内容*/
@property (nonatomic, copy) NSString *content;

/** 配图地址。多图时返回多图链接。无配图返回“[]” */
@property (nonatomic, strong) NSArray *photos;
@property (nonatomic, copy) NSString *images;

@property (nonatomic, copy) NSString *uid; // 用户id
@property (nonatomic, copy) NSString *nickName; // 用户昵称
@property (nonatomic, copy) NSString *headPic; // 用户头像

@property (nonatomic, assign) USERTYPE type;

/**	创建时间*/
@property (nonatomic, copy) NSString *created_at;

///**	分享数*/
@property (nonatomic, assign) NSUInteger shares_count;
///**	评论数*/
//@property (nonatomic, assign) NSInteger replies_count;
/**	点赞数*/
@property (nonatomic, assign) NSUInteger attitudes_count;
/**	自己是否点赞*/
@property (nonatomic, assign, getter=isLike) BOOL like;

/**	回复*/
@property (nonatomic, strong) NSMutableArray *replies;

@end