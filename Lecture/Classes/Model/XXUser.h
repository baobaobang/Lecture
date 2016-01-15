//
//  XXUser.h
//  Lecture
//
//  Created by 陈旭 on 16/1/15.
//  Copyright © 2016年 陈旭. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XXUser : NSObject
//questionCell.userNameLabel.text = @"李灵黛";
//questionCell.userVipView.image = [UIImage imageNamed:@"user_vip_1"];
//[questionCell.userIconBtn setBackgroundImage:[UIImage imageNamed:@"userIcon_1"] forState:UIControlStateNormal];
//questionCell.questionContentLabel.text = @"张医生辛苦，听好多妈妈说宝宝接种了流感疫苗后感觉更容易感冒了，社区让打流感疫苗我吓的一直没去，是不是真的如此呢，前天带宝宝出了门回来夜里就发烧了";
/**	NSString	用户姓名*/
@property (nonatomic, copy) NSString *name;
/**	NSString	用户vip等级*/
@property (nonatomic, copy) NSString *vip;
/**	NSString	用户头像*/
@property (nonatomic, copy) NSString *icon;

@end
