//
//  GlobalDef.h
//  lecture
//
//  Created by mortal on 16/1/21.
//  Copyright © 2016年 禾医健康科技. All rights reserved.
//

#ifndef GlobalDef_h
#define GlobalDef_h

#import "AppDelegate.h"
#import "Lecture-Swift.h"
#import "SVProgressHUD.h"
#import "UIImageView+WebCache.h"

//判断iphone6
#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)

//判断iphone6+
#define iPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(960, 1704), [[UIScreen mainScreen] currentMode].size) : NO)

//判断iphone5s
#define iPhone5s ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

//判断iphone4s
#define iPhone4s ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)

//AppDelegate
#define Delegate (AppDelegate *)[UIApplication sharedApplication].delegate



#define SWIDTH [UIScreen mainScreen].bounds.size.width
#define SHEIGHT [UIScreen mainScreen].bounds.size.height

#define RGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

#define darkTextColor RGB(51,51,51)
#define navColor RGB(66, 179, 227)
#define RandomColor RGB(arc4random()%256,arc4random()%256,arc4random()%256)

#define AlertMessage(msg) [[[UIAlertView alloc]initWithTitle:msg message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show]

//
#define UserDefaultsSave(value,key) [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];[[NSUserDefaults standardUserDefaults] synchronize]

#define UserDefaultsGet(key) [[NSUserDefaults standardUserDefaults] objectForKey:key]

#define ACCESS_TOKEN UserDefaultsGet(@"access_token")
#define isExpert UserDefaultsGet(@"isExpert")
#define Mobile UserDefaultsGet(@"mobile")
#define WS(weakSelf) __weak typeof(self) weakSelf = self


#define QINIU_HOST @"http://7xoadl.com2.z0.glb.qiniucdn.com"

//音频采样率
#define SAMPLERATE 10000.0  //44100.0

#define UMKey @"569eec33e0f55a6ad500118c"//友盟Key
#define QQAppKey @"QNusQiGZCItieACl"
#define QQAppId @"1105197190"




//#define WXAppKey @"wxe742b302525bd7fb"
#define WXAppId @"wx6174614702fee735"
#define WXAppSecret @"b32e3398bc94a864121ab094a7d41051"

#define WBAppKey @"3076527061"
#define WBAppSecret @"a7aa6e671728fcc0be616dbbedbe1335"

#endif /* GlobalDef_h */
