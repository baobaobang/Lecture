//
//  XXReply.h
//  Lecture
//
//  Created by 陈旭 on 16/1/28.
//  Copyright © 2016年 陈旭. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XXExpert.h"
#import "XXUser.h"

@interface XXReply : NSObject
/**	问题文字内容*/
@property (nonatomic, copy) NSString *text;


/**	问题音频urlStr*/
@property (nonatomic, copy) NSString *mp3Str;

/**	回复问题的用户*/
@property (nonatomic, strong) XXUser *user;

/**	回复问题的专家*/
@property (nonatomic, strong) XXExpert *expert;
@end
