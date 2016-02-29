//
//  XXPlayerToolBar.m
//  Lecture
//
//  Created by 陈旭 on 16/1/20.
//  Copyright © 2016年 陈旭. All rights reserved.
//

#import "XXPlayerToolBar.h"
#import "AudioTool.h"

// 页码字体
#define XXPlayerTimeLabelFont [UIFont systemFontOfSize:15]

@interface XXPlayerToolBar ()
/** 横屏按钮 */
@property (nonatomic, weak) UIButton *landscapeBtn;

/** 定时器 */
@property(strong,nonatomic)CADisplayLink *link;

@end

@implementation XXPlayerToolBar

#pragma mark - 生命周期

-(void)dealloc{
    //移除定时器
    [XXNotificationCenter removeObserver:self];

    [self.link removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    self.link = nil;
}

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
        [playBtn setBackgroundImage:[UIImage imageNamed:@"middle_progressbar_off"] forState:UIControlStateNormal];
        [playBtn setBackgroundImage:[UIImage imageNamed:@"middle_progressbar_on"] forState:UIControlStateSelected];
        
        [self addSubview:playBtn];
        self.playBtn = playBtn;
        
        // timeSlider
        UISlider *timeSlider = [[UISlider alloc] init];
        UIImage *thumbImage = [UIImage imageNamed:@"middle_progressbar_ball"];
        [timeSlider setMinimumTrackTintColor:XXColorTint];
        [timeSlider setThumbImage:thumbImage forState:UIControlStateNormal];
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
        
        // landscapeBtn
        UIButton *landscapeBtn = [[UIButton alloc] init];
        [landscapeBtn addTarget:self action:@selector(clickLandscapeBtn:) forControlEvents:UIControlEventTouchUpInside];
        [landscapeBtn setNBg:@"middle_progressbar_landscape" hBg:@"middle_progressbar_landscape"];
        [self addSubview:landscapeBtn];
        self.landscapeBtn = landscapeBtn;
        
        // 开启定时器
        [self.link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
        
        [XXNotificationCenter addObserver:self selector:@selector(updateTotalTimeLabel) name:XXChangePageNotification object:nil];
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
//    CGSize totalSize = [self.totalTimeLabel.text sizeWithFont:XXPlayerTimeLabelFont];
    CGFloat totalW = 45;
    CGFloat totalH = self.height;
    CGFloat totalX = playW;
    CGFloat totalY = 0;
    self.totalTimeLabel.frame = CGRectMake(totalX, totalY, totalW, totalH);
    
    // landscapeBtn
    CGFloat landscapeH = self.height;
    CGFloat landscapeW = landscapeH;
    CGFloat landscapeX = self.width - landscapeW;
    CGFloat landscapeY = 0;
    self.landscapeBtn.frame = CGRectMake(landscapeX, landscapeY, landscapeW, landscapeH);
    
    // currentTimeLabel
//    CGSize currentSize = [self.currentTimeLabel.text sizeWithFont:XXPlayerTimeLabelFont];
    CGFloat currentW = 45;
    CGFloat currentH = self.height;
    CGFloat currentX = landscapeX - currentW;
    CGFloat currentY = 0;
    self.currentTimeLabel.frame = CGRectMake(currentX, currentY, currentW, currentH);
    
    // timeSlider
    CGFloat sliderX = CGRectGetMaxX(self.totalTimeLabel.frame);
    CGFloat sliderY = 0;
    CGFloat sliderW = self.currentTimeLabel.x - CGRectGetMaxX(self.totalTimeLabel.frame);
    CGFloat sliderH = self.height;
    self.timeSlider.frame = CGRectMake(sliderX, sliderY, sliderW, sliderH);
    
    // 网络不好的情况（设置各个子控件的默认数据）
    if ([AudioTool shareAudioTool].streamPlayer == nil) {
        [self setUpDefaultData];
    }
}

#pragma mark -设置各个子控件的默认数据-网络不好的情况
- (void)setUpDefaultData{
    
    NSString *durationStr = [NSString getHourMinuteSecondWithSecond:0];
    self.totalTimeLabel.text = [NSString stringWithFormat:@"%@", durationStr];
    
    NSString *currentTimeStr = [NSString getHourMinuteSecondWithSecond:0];
    self.currentTimeLabel.text = [NSString stringWithFormat:@"%@", currentTimeStr];
}


#pragma mark - 更新总时间

- (void)updateTotalTimeLabel{
    // 设置totalTimeLabel
//    AVPlayerItem *playerItem = [AudioTool shareAudioTool].streamPlayer.currentItem;
//    
//    CMTime totalTime = playerItem.duration;
//    CGFloat duration = CMTimeGetSeconds(totalTime);
//    self.totalTimeLabel.text = [NSString getHourMinuteSecondWithSecond:duration];
//    
//    // 设置currentTimeLabel
//    CMTime currentTime = playerItem.currentTime;
//    self.currentDuration = CMTimeGetSeconds(currentTime);
//    self.currentTimeLabel.text = [NSString getHourMinuteSecondWithSecond:self.currentDuration];
//    
//    // 设置slider
//    self.timeSlider.maximumValue = duration;
//    self.timeSlider.value = self.currentDuration;
}


#pragma mark - 定时器监听currentTime属性变化，刷新进度条和currentTimeLabel
- (void)currentTimeUpdate{
    CMTime currentTime = [AudioTool shareAudioTool].streamPlayer.currentItem.currentTime;
    self.currentDuration = (CGFloat)currentTime.value/currentTime.timescale;
    if (self.isDragging == NO){
        // 如果没有在拖拽进度条，就根据currentTime更新进度条
        self.timeSlider.value = self.currentDuration;
    }
    //2.更新当前时间
    self.currentTimeLabel.text = [NSString getHourMinuteSecondWithSecond:self.currentDuration];
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

- (void)clickLandscapeBtn:(UIButton *)btn{
    [XXNotificationCenter postNotificationName:XXLandscapeBtnDidClickNotification object:nil];
}

@end
