//
//  XXReply.h
//  Lecture
//
//  Created by 陈旭 on 16/1/28.
//  Copyright © 2016年 陈旭. All rights reserved.
//

#import "XXBaseModel.h"

@interface XXReply : XXBaseModel
// 回复id
@property (nonatomic, copy) NSString *ID;

// 问题id
@property (nonatomic, copy) NSString *questionId;

@property (nonatomic, copy) NSString *uid; // 用户id
@property (nonatomic, copy) NSString *nickName; // 用户昵称
@property (nonatomic, copy) NSString *headPic; // 用户头像

/**	问题内容*/
@property (nonatomic, copy) NSString *content;

/**	问题音频urlStr*/
@property (nonatomic, copy) NSString *mp3Str;//FIXME: 少字段

@property (nonatomic, assign) USERTYPE type;

- (NSString *)buildCommentText;
@end
