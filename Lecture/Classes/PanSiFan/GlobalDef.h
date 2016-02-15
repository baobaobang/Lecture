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

//判断iphone6
#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)

//判断iphone6+
#define iPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)

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
//sdf;lldkdkdkk
#define UMKey @"569eec33e0f55a6ad500118c"//友盟Key
#define QQAppKey @"vdjbJ05YoYv4VQrq"
#define QQAppId @"1104953896"

#define WXAppKey @"wxe742b302525bd7fb"
#define WXAppId @"wxf6bc0f0a9ff6e170"
#define WXAppSecret @"72403db9b4dd66857a5ef1f848626ef5"


#endif /* GlobalDef_h */
