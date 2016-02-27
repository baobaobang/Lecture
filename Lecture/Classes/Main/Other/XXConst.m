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
const CGFloat kXXJoinLectureActionSheetHeight = 180;
const CGFloat kXXQuestionVCTextViewOriginalHeight = 38; // textview初始高度
const CGFloat kXXQuestionVCTextViewMaxHeight = 130; // textview初始高度
const CGFloat kXXQuestionReplyCellHeight = 30;
/** 字体*/
const CGFloat kXXJoinLectureActionSheetLabelFont = 16;
const CGFloat kXXJoinLectureActionSheetDoneBtnFont = 18;
/** 时间*/
const CGFloat kXXHideAndShowPicViewDuration = 0.4;
const CGFloat kXXJoinLectureActionSheetDuration = 0.3;

/** Identifier*/
NSString * const XXQuestionCellReuseId = @"QuestionCell";
NSString * const XXQuestionReplyCellReuseId = @"QuestionReplyCellReuseId";
NSString * const XXQuestionReplyUserCellReuseId = @"QuestionReplyUserCellReuseId";
/** 其他*/
const NSUInteger kXXQuestionVCTextViewMaxWords = 300;// 最大字数限制
const CGFloat kXXJoinLectureActionSheetAlpha = 0.4;

#pragma mark - 讲座中
/** frame*/
const CGFloat kXXPlayerToolBarHeight = 40;
const CGFloat kXXOnlineHeaderViewHeight = 44;
/** 字体*/
/** 时间*/
const CGFloat kXXPlayerVCChageToLandscapeDuration = 0.3; // 横屏切换时间

/** Identifier*/
NSString * const XXPlayerPicViewCellIdentifier = @"XXPlayerPicViewCellIdentifier";

/** 通知*/
NSString * const XXQuestionToolbarShareButtonClickNotification = @"XXQuestionToolbarShareButtonClickNotification";
NSString * const XXQuestionToolbarUnlikeButtonClickNotification = @"XXQuestionToolbarShareButtonClickNotification";
NSString * const XXLandscapeBtnDidClickNotification = @"XXLandscapeBtnDidClickNotification";

NSString * const XXStartPlayingNotification = @"XXStartPlayingNotification";
NSString * const XXStopPlayingNotification = @"XXStopPlayingNotification";

#pragma mark - 问题
NSString * const XXReplyCellDidClickNotification = @"XXReplyCellDidClickNotification";
@end
