//
//  XXUser.h
//  Lecture
//
//  Created by 陈旭 on 16/1/15.
//  Copyright © 2016年 陈旭. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XXUser : NSObject

/**	string	字符串型的用户UID*/
@property (nonatomic, copy) NSString *idstr;
/**	NSString	用户姓名*/
@property (nonatomic, copy) NSString *name;
/**	BOOL	用户是否是vip*/
@property (nonatomic, assign, getter=isVip) BOOL vip;
/**	NSString	用户vip等级*/
@property (nonatomic, copy) NSString *vipLevel;
/**	string	用户头像地址，50×50像素*/
@property (nonatomic, copy) NSString *icon;

// 获取当前登陆的用户
//+ (instancetype)currentUser;

@end
