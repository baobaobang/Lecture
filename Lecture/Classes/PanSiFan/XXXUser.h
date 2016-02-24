//
//  XXXUser.h
//  Lecture
//
//  Created by mortal on 16/2/23.
//  Copyright © 2016年 陈旭. All rights reserved.
//

#import "XXXBaseModel.h"

typedef NS_ENUM(NSInteger, USERTYPE) {//用户类型
    USERTYPE_NORMAL = 0,//普通用户
    USERTYPE_EXPERT = 1//专家用户
};

typedef NS_ENUM(NSInteger, THIRDPARTYTYPE) {//第三方登录类型
    THIRDPARTYTYPE_WX = 1,
    THIRDPARTYTYPE_QQ = 2,
    THIRDPARTYTYPE_WB = 3
};


@interface XXXUser : XXXBaseModel

@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *headPic;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *weChatNickName;
@property (nonatomic, copy) NSString *weChatHeadPic;
@property (nonatomic, copy) NSString *weChatOpenID;
@property (nonatomic, copy) NSString *weboUid;
@property (nonatomic, copy) NSString *weboHeadPic;
@property (nonatomic, copy) NSString *weboNickName;
@property (nonatomic, copy) NSString *qqOpenID;
@property (nonatomic, copy) NSString *qqNickName;
@property (nonatomic, copy) NSString *qqHeadPic;
@property (nonatomic, assign) USERTYPE type;
@property (nonatomic, assign) THIRDPARTYTYPE thirdPartyType;
@property (nonatomic, copy) NSString *token;
@property (nonatomic, copy) NSString *status;


@end

