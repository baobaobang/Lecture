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


// 项目默认颜色（浅蓝色）
#define XXTintColor XXColor(47, 180, 254)

// 项目默认文字颜色
#define XXTintTitleColor [UIColor whiteColor]

// 项目默认选中状态颜色（浅浅蓝色）
#define XXSelectedColor XXColor(175, 220, 250)

// 精选提问默认颜色（浅绿色）
#define XXQuestionTintColor XXColor(75, 217, 130)

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
