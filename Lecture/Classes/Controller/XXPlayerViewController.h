//
//  XXPlayerViewController.h
//  Lecture
//
//  Created by 陈旭 on 16/1/20.
//  Copyright © 2016年 陈旭. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HMMusic;
@interface XXPlayerViewController : UIViewController

//当前播放的音乐
@property(nonatomic,strong)HMMusic *currentMusic;
// 播放状态 默认暂停状态
@property(assign,nonatomic,getter=isPlaying)BOOL playing;
@end
