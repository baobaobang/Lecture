//
//  XXConst.h
//  Lecture
//
//  Created by 陈旭 on 16/1/9.
//  Copyright © 2016年 陈旭. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XXConst : NSObject

//extern NSString * const XXNavigationTitleFont;

extern const CGFloat PlayerToolBarHeight;
extern NSString * const XXCollectionViewCellIdentifier;
extern NSString * const XXPlayerPicViewWillHide;
extern NSString * const XXPlayerPicViewWillShow;
extern NSString * const XXQuestionToolbarShareButtonClick;
extern NSString * const XXQuestionToolbarUnlikeButtonClick;
// 删除文字的通知
extern NSString * const XXTextDidDeleteNotification;

#define WEAKSELF  typeof(self) __weak weakSelf=self;

#define XXWindow [[UIApplication sharedApplication].delegate window]

// RGB颜色
#define XXColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

// 随机色
#define XXRandomColor XXColor(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))

// 测试颜色
#define XXTestColor [UIColor redColor]

// 通知中心
#define XXNotificationCenter [NSNotificationCenter defaultCenter]

// 打印测试
#define XXTestLog XXLog(@"%s", __func__)

// 主窗口
#define XXKeyWindow [UIApplication sharedApplication].keyWindow

// 屏幕的宽度
#define XXScreenWidth [UIScreen mainScreen].bounds.size.width

// 屏幕的高度
#define XXScreenHeight [UIScreen mainScreen].bounds.size.height

// 项目默认颜色（浅蓝色）
#define XXColorTint XXColor(47, 180, 254)

// 项目默认文字颜色
#define XXColorText [UIColor whiteColor]

// 项目默认选中状态颜色（浅浅蓝色）
#define XXSelectedColor XXColor(175, 220, 250)

// 精选提问默认颜色（浅绿色）
#define XXColorGreen XXColor(75, 217, 130)

// 精选提问选中状态颜色（深绿色）
#define XXQuestionSelectedColor XXColor(5, 128, 0)

// 高宽比
#define XXPlayerPicViewHeightWidthRatio 0.5

// 状态栏和导航栏的总高度
#define XXStatusAndNavBarHeight 64

// 专家简介部分的高度
#define XXExpertProfileViewHeight 120

// 报名活动按钮的高度
#define XXJoinButtonHeight 44

// tableview header的高度
#define XXHeaderViewHeight 35
@end
