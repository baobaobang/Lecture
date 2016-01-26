//
//  XXConst.h
//  Lecture
//
//  Created by 陈旭 on 16/1/9.
//  Copyright © 2016年 陈旭. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XXConst : NSObject
#pragma mark - 全局

/** 简称*/
#define XXKeyWindow [UIApplication sharedApplication].keyWindow// 主窗口
#define XXTopWindow [[UIApplication sharedApplication].windows lastObject]// 最顶层的window
#define WEAKSELF  typeof(self) __weak weakSelf=self;// 弱指针
#define XXNotificationCenter [NSNotificationCenter defaultCenter]// 通知中心
#define XXTestLog XXLog(@"%s", __func__)// 打印测试
#define XXScreenWidth [UIScreen mainScreen].bounds.size.width// 屏幕的高度
#define XXScreenHeight [UIScreen mainScreen].bounds.size.height// 屏幕的宽度

/** 颜色*/
#define XXColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]// RGB颜色
#define XXRandomColor XXColor(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))// 随机色
#define XXTestColor [UIColor redColor]// 测试颜色
#define XXColorTint XXColor(47, 180, 254)// 项目默认颜色（浅蓝色）
#define XXColorText [UIColor whiteColor]// 项目默认文字颜色
#define XXSelectedColor XXColor(175, 220, 250)// 项目默认选中状态颜色（浅浅蓝色）
/** frame*/
extern const CGFloat kXXStatusAndNavBarHeight;// 状态栏和导航栏的总高度

#pragma mark - 首页

#pragma mark - 提问
/** 通知*/
extern NSString * const XXTextDidDeleteNotification;

#pragma mark - 讲座前
/** frame*/
extern const CGFloat kXXPlayerPicViewHeightWidthRatio;// PlayerPicView高宽比
extern const CGFloat kXXExpertHeaderViewHeight;// 专家简介头部的高度
extern const CGFloat kXXExpertTableViewHeight;// 专家简介的高度
extern const CGFloat kXXQuestionHeaderViewHeight;//精选提问头部高度
extern const CGFloat kXXJoinButtonHeight;// 报名活动按钮的高度
extern const CGFloat kXXJoinLectureActionSheetHeight;

/** 字体*/
extern const CGFloat kXXJoinLectureActionSheetLabelFont;
extern const CGFloat kXXJoinLectureActionSheetDoneBtnFont;
/** 颜色*/
#define XXColorGreen XXColor(75, 217, 130)// 精选提问默认颜色（浅绿色）
#define XXQuestionSelectedColor XXColor(5, 128, 0)// 精选提问选中状态颜色（深绿色）

/** 时间*/
extern const CGFloat kXXHideAndShowPicViewDuration;//收起图片和专家简介的时间
extern const CGFloat kXXJoinLectureActionSheetDuration;

extern const CGFloat kXXJoinLectureActionSheetAlpha;

#pragma mark - 讲座中
/** frame*/
extern const CGFloat kXXPlayerToolBarHeight; //播放条的高度
extern const CGFloat kXXOnlineHeaderViewHeight;//在线交流头部高度
/** Identifier*/
extern NSString * const XXPlayerPicViewCellIdentifier;//播放图片的cell
/** 通知*/
extern NSString * const XXQuestionToolbarShareButtonClickNotification;
extern NSString * const XXQuestionToolbarUnlikeButtonClickNotification;

@end
