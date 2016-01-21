//
//  XXPlayerToolBar.m
//  Lecture
//
//  Created by 陈旭 on 16/1/20.
//  Copyright © 2016年 陈旭. All rights reserved.
//

#import "XXPlayerToolBar.h"
#import <AVFoundation/AVFoundation.h>

// 页码字体
#define XXPlayerTimeLabelFont [UIFont systemFontOfSize:15]

@interface XXPlayerToolBar ()

/** 定时器 */
@property(strong,nonatomic)CADisplayLink *link;

@end

@implementation XXPlayerToolBar

#pragma mark - 懒加载
-(CADisplayLink *)link{
    if (!_link) {
        _link = [CADisplayLink displayLinkWithTarget:self selector:@selector(currentTimeUpdate)];
    }
    
    return _link;
}

#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        // playBtn
        UIButton *playBtn = [[UIButton alloc] init];
        [playBtn addTarget:self action:@selector(clickPlayBtn:) forControlEvents:UIControlEventTouchUpInside];
        [playBtn setNBg:@"playbar_playbtn_nomal" hBg:@"playbar_playbtn_click"];
        [self addSubview:playBtn];
        self.playBtn = playBtn;
        
        // timeSlider
        UISlider *timeSlider = [[UISlider alloc] init];
        [timeSlider addTarget:self action:@selector(beginDraggingSlider:) forControlEvents:UIControlEventTouchDown];
        [timeSlider addTarget:self action:@selector(didStopDraggingSlider:) forControlEvents:UIControlEventTouchUpInside];
        [timeSlider addTarget:self action:@selector(didStopDraggingSlider:) forControlEvents:UIControlEventTouchUpOutside];
        [timeSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:timeSlider];
        self.timeSlider = timeSlider;
        
        // currentTimeLabel
        UILabel *currentTimeLabel = [[UILabel alloc] init];
        currentTimeLabel.font = XXPlayerTimeLabelFont;
        currentTimeLabel.textColor = [UIColor whiteColor];
        currentTimeLabel.textAlignment = NSTextAlignmentCenter;// 右对齐
        [self addSubview:currentTimeLabel];
        self.currentTimeLabel = currentTimeLabel;
        
        // totalTimeLabel
        UILabel *totalTimeLabel = [[UILabel alloc] init];
        totalTimeLabel.font = XXPlayerTimeLabelFont;
        totalTimeLabel.textColor = [UIColor whiteColor];
        totalTimeLabel.textAlignment = NSTextAlignmentCenter;// 右对齐
        [self addSubview:totalTimeLabel];
        self.totalTimeLabel = totalTimeLabel;
        
        // 开启定时器
        [self.link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }
    return self;
}


- (void)layoutSubviews{
    [super layoutSubviews];
    
    // playBtn
    CGFloat playX = 0;
    CGFloat playY = 0;
    CGFloat playH = self.height;
    CGFloat playW = playH;
    self.playBtn.frame = CGRectMake(playX, playY, playW, playH);
    
    // totalTimeLabel
    CGSize totalSize = [self.totalTimeLabel.text sizeWithFont:XXPlayerTimeLabelFont];
    CGFloat totalW = totalSize.width > 45 ? 60 : 45;
    CGFloat totalH = self.height;
    CGFloat totalX = self.width - totalW;
    CGFloat totalY = 0;
    self.totalTimeLabel.frame = CGRectMake(totalX, totalY, totalW, totalH);
    
    // currentTimeLabel
    CGSize currentSize = [self.currentTimeLabel.text sizeWithFont:XXPlayerTimeLabelFont];
    CGFloat currentW = totalSize.width > 42 ? 55 : 42;
    CGFloat currentH = self.height;
    CGFloat currentX = self.totalTimeLabel.x - currentW;
    CGFloat currentY = 0;
    self.currentTimeLabel.frame = CGRectMake(currentX, currentY, currentW, currentH);
    
    // timeSlider
    CGFloat sliderX = CGRectGetMaxX(self.playBtn.frame);
    CGFloat sliderY = 0;
    CGFloat sliderW = self.currentTimeLabel.x - sliderX;
    CGFloat sliderH = self.height;
    self.timeSlider.frame = CGRectMake(sliderX, sliderY, sliderW, sliderH);
}

#pragma mark - 生命周期

-(void)dealloc{
    //移除定时器
    [self.link removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
}


// 设置初始化时候的显示
- (void)setPlayer:(AVAudioPlayer *)player{
    _player = player;
    
    // 设置totalTimeLabel
    double duration = player.duration;
    NSString *durationStr = [NSString getMinuteSecondWithSecond:duration];
    self.totalTimeLabel.text = [NSString stringWithFormat:@"/ %@", durationStr];
    
    // 设置currentTimeLabel
    self.currentTimeLabel.text = [NSString getMinuteSecondWithSecond:player.currentTime];
    
    // 设置slider
    self.timeSlider.maximumValue = duration;
    self.timeSlider.value = player.currentTime;
}


#pragma mark - 定时器监听currentTime属性变化，刷新进度条和currentTimeLabel
- (void)currentTimeUpdate{
    if (self.isDragging == NO){
        // 如果没有在拖拽进度条，就根据currentTime更新进度条
        self.timeSlider.value = self.player.currentTime;
    }
    //2.更新当前时间
    self.currentTimeLabel.text = [NSString getMinuteSecondWithSecond:self.player.currentTime];
    [self.currentTimeLabel sizeToFit];
}

#pragma mark - 代理方法

- (void)clickPlayBtn:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(playerToolBar:didClickPlayBtn:)]) {
        [self.delegate playerToolBar:self didClickPlayBtn:btn];
    }
}

- (void)beginDraggingSlider:(UISlider *)slider{
    if ([self.delegate respondsToSelector:@selector(playerToolBar:didBeginDraggingSlider:)]) {
        [self.delegate playerToolBar:self didBeginDraggingSlider:slider];
    }
}

- (void)didStopDraggingSlider:(UISlider *)slider{
    if ([self.delegate respondsToSelector:@selector(playerToolBar:didStopDraggingSlider:)]) {
        [self.delegate playerToolBar:self didStopDraggingSlider:slider];
    }
}

- (void)sliderValueChanged:(UISlider *)slider{
    if ([self.delegate respondsToSelector:@selector(playerToolBar:sliderValueChanged:)]) {
        [self.delegate playerToolBar:self sliderValueChanged:slider];
    }
}

@end
