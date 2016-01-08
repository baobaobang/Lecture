//
//  XXPlayerView.h
//  Lecture
//
//  Created by 陈旭 on 16/1/7.
//  Copyright © 2016年 陈旭. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CZMusic;
@interface XXPlayerView : UIView
+ (instancetype)playerView;

@property(nonatomic,strong)CZMusic *playingMusic;//当前播放的音乐

/*
 *播放状态 默认暂停状态
 */
@property(assign,nonatomic,getter=isPlaying)BOOL playing;
@end
