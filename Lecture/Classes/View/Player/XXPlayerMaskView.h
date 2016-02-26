//
//  XXPlayerMaskView.h
//  Lecture
//
//  Created by 陈旭 on 16/1/20.
//  Copyright © 2016年 陈旭. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    XXPlayerMaskViewButtonTypeShare,
    XXPlayerMaskViewButtonTypePlay,
    XXPlayerMaskViewButtonTypePrevious,
    XXPlayerMaskViewButtonTypeNext
}XXPlayerMaskViewButtonType;

@class XXPlayerMaskView;

@protocol XXPlayerMaskViewDelegate <NSObject>

@optional
- (void)playerMaskView:(XXPlayerMaskView *)playerMaskView didClickBtnType:(XXPlayerMaskViewButtonType)type;

@end

@interface XXPlayerMaskView : UIView
/** 页码标签 */
@property (weak, nonatomic) UILabel *pageNumberLabel;
/** 当前显示的item索引 */
@property(assign, nonatomic) NSInteger currentItem;
/** 音乐数据 */
@property(strong,nonatomic) NSArray *pages;

@property (nonatomic, weak) id<XXPlayerMaskViewDelegate> delegate;
@end
