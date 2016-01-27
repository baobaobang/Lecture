//
//  XXConst.m
//  Lecture
//
//  Created by 陈旭 on 16/1/9.
//  Copyright © 2016年 陈旭. All rights reserved.
//

#import "XXConst.h"

@implementation XXConst
#pragma mark - 全局
/** frame*/
const CGFloat kXXStatusAndNavBarHeight = 64;// 状态栏和导航栏的总高度
/** 字体*/
const CGFloat kXXTextFont = 18;

#pragma mark - 首页
/** frame*/
/** 字体*/
/** 时间*/

#pragma mark - 提问
/** frame*/
/** 字体*/
/** 时间*/
/** 通知*/
NSString * const XXTextDidDeleteNotification = @"XXTextDidDeleteNotification";// 删除文字的通知

#pragma mark - 讲座前
/** frame*/
const CGFloat kXXPlayerPicViewHeightWidthRatio = 0.5;// 高宽比
const CGFloat kXXExpertHeaderViewHeight = 44;
const CGFloat kXXExpertTableViewHeight = 80;
const CGFloat kXXQuestionHeaderViewHeight = 44;
const CGFloat kXXJoinButtonHeight = 44;// 报名活动按钮的高度
const CGFloat kXXJoinLectureActionSheetHeight = 200;

/** 字体*/
const CGFloat kXXJoinLectureActionSheetLabelFont = 16;
const CGFloat kXXJoinLectureActionSheetDoneBtnFont = 18;
/** 时间*/
const CGFloat kXXHideAndShowPicViewDuration = 0.4;
const CGFloat kXXJoinLectureActionSheetDuration = 0.3;

const CGFloat kXXJoinLectureActionSheetAlpha = 0.4;

#pragma mark - 讲座中
/** frame*/
const CGFloat kXXPlayerToolBarHeight = 34;
const CGFloat kXXOnlineHeaderViewHeight = 44;
/** 字体*/
/** 时间*/




/** Identifier*/
NSString * const XXPlayerPicViewCellIdentifier = @"XXPlayerPicViewCellIdentifier";

/** 通知*/
NSString * const XXQuestionToolbarShareButtonClickNotification = @"XXQuestionToolbarShareButtonClickNotification";
NSString * const XXQuestionToolbarUnlikeButtonClickNotification = @"XXQuestionToolbarShareButtonClickNotification";



@end
