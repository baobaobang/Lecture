//
//  XXPlayerToolBar.h
//  Lecture
//
//  Created by 陈旭 on 16/1/20.
//  Copyright © 2016年 陈旭. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AVPlayer, XXPlayerToolBar;

@protocol XXPlayerToolBarDelegate <NSObject>

@optional
- (void)playerToolBar:(XXPlayerToolBar *)toolBar didClickPlayBtn:(UIButton *)btn;
- (void)playerToolBar:(XXPlayerToolBar *)toolBar didBeginDraggingSlider:(UISlider *)slider;
- (void)playerToolBar:(XXPlayerToolBar *)toolBar didStopDraggingSlider:(UISlider *)slider;
- (void)playerToolBar:(XXPlayerToolBar *)toolBar sliderValueChanged:(UISlider *)slider;
@end

@interface XXPlayerToolBar : UIView

/** 播放按钮 */
@property (weak, nonatomic) UIButton *playBtn;
/** 时间进度条 */
@property (weak, nonatomic) UISlider *timeSlider;
/** 当前播放时间 */
@property (weak, nonatomic) UILabel *currentTimeLabel;
/** 总播放时长 */
@property (weak, nonatomic) UILabel *totalTimeLabel;


/** 播放器 */
@property(nonatomic, weak) AVPlayer *player;

@property (nonatomic, weak) id<XXPlayerToolBarDelegate> delegate;
/** 是否正在拖拽 */
@property(assign,nonatomic,getter=isDragging)BOOL dragging;

@property (nonatomic, assign) CGFloat currentDuration;

@end
