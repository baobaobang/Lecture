//
//  XXPlayerView.m
//  Lecture
//
//  Created by 陈旭 on 16/1/7.
//  Copyright © 2016年 陈旭. All rights reserved.
//

#import "XXPlayerView.h"
#import "CZMusicTool.h"
#import "MJExtension.h"
#import "UIButton+CZ.h"

#define playerToolBarHeight 34

@interface XXPlayerView () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *pptView;
@property (weak, nonatomic) IBOutlet UIView *playerToolBar;
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *imageViews;
/** 当前播放音乐索引 */
@property(assign, nonatomic)NSInteger musicIndex;//
/** 音乐数据 */
@property(strong,nonatomic) NSArray *musics;
/** 播放按钮 */
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
/** 时间进度条 */
@property (weak, nonatomic) IBOutlet UISlider *timeSlider;
/** 当前播放时间 */
@property (weak, nonatomic) IBOutlet UILabel *currentTimeLabel;
/** 总播放时长 */
@property (weak, nonatomic) IBOutlet UILabel *totalTimeLabel;
/** 定时器 */
@property(strong,nonatomic)CADisplayLink *link;
/** 是否正在拖拽 */
@property(assign,nonatomic,getter=isDragging)BOOL dragging;
@end


@implementation XXPlayerView

#pragma mark - 懒加载

-(NSArray *)musics{
    
    if (!_musics) {
        _musics = [CZMusic objectArrayWithFilename:@"songs.plist"];
    }
    
    return _musics;
}

-(CADisplayLink *)link{
    if (!_link) {
        _link = [CADisplayLink displayLinkWithTarget:self selector:@selector(update)];
    }
    
    return _link;
}

#pragma mark - 初始化
+ (instancetype)playerView{
    return [[[NSBundle mainBundle] loadNibNamed:@"XXPlayerView" owner:nil options:nil] lastObject];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        self.playerToolBar.backgroundColor = HWColor(38, 38, 38);
    }
    return self;
}


- (void)awakeFromNib{
    
    // 创建一个scrollView：用于显示所有的ppt图片
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    [self.pptView addSubview:scrollView];
    self.scrollView = scrollView;
    
    
    // 添加imageView到scrollView中
    for (int i = 0; i < self.musics.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        // 设置图片
        CZMusic *music = self.musics[i];
        imageView.image = [UIImage imageNamed:music.singerIcon];
        [self.scrollView addSubview:imageView];
    }
    
    // 设置scrollView的其他属性
    // 如果想要某个方向上不能滚动，那么这个方向对应的尺寸数值传0即可
    scrollView.bounces = NO; // 去除弹簧效果
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.delegate = self;
    
    // 重新初始化一个 "播放器"
    [self playMusic];
    
    // 设置slider 按钮的图片
    UIImage *originSliderImage = [UIImage imageNamed:@"playbar_slider_thumb"];
    UIImage *scaledSliderImage = [UIImage originImage:originSliderImage scaleToSize:CGSizeMake(playerToolBarHeight, playerToolBarHeight)];
    [self.timeSlider setThumbImage:scaledSliderImage forState:UIControlStateNormal];
    
    // 开启定时器
    [self.link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    
}

#pragma mark - 生命周期

-(void)dealloc{
    //移除定时器
    [self.link removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
}

#pragma mark - 尺寸布局

/**
 *  设置子控件的frame
 */
- (void)layoutSubviews{
    [super layoutSubviews];
    
    // 设置scrollView的frame
    self.scrollView.frame = self.pptView.bounds;
    
    // 设置imageView的frame
    CGFloat scrollW = self.scrollView.width;
    CGFloat scrollH = self.scrollView.height;
    NSUInteger musicCount = self.musics.count;
    for (int i = 0; i<musicCount; i++) {
        //TODO:imageView的创建应该放到awakeFromNib中
        UIImageView *imageView = self.scrollView.subviews[i];
        imageView.width = scrollW;
        imageView.height = scrollH;
        imageView.y = 0;
        imageView.x = i * scrollW;
    }
    
    // 设置scrollView的contentSize
    self.scrollView.contentSize = CGSizeMake(musicCount * scrollW, 0);
}

#pragma mark - IBAction

- (IBAction)playBtnClick:(id)sender {
    
    //更改播放状态
    self.playing = !self.playing;
    //
    if (self.playing) {//播放音乐
        HWLog(@"播放音乐");
        //1.如果是播放的状态，按钮的图片更改为暂停的状态
        [self.playBtn setNBg:@"playbar_pausebtn_nomal" hBg:@"playbar_pausebtn_click"];
        [self play];
    }else{//暂停音乐
        HWLog(@"暂停音乐");
        //2.如果当前是暂停的状态，按钮的图片更改为播放的状态
        [self.playBtn setNBg:@"playbar_playbtn_nomal" hBg:@"playbar_playbtn_click"];
        [self pause];
    }
    
}

#pragma mark slider 点击的时候，暂停播放
- (IBAction)stopPlay:(UISlider *)sender {
    //更改拖拽的状态
    self.dragging = YES;
    
    [[CZMusicTool sharedCZMusicTool] pause];
}

#pragma mark slider拖动
- (IBAction)sliderChange:(UISlider *)sender {
    //1.播放器的进度
    [CZMusicTool sharedCZMusicTool].player.currentTime = sender.value;
    
    //2.工具条的当前时间
    self.currentTimeLabel.text = [NSString getMinuteSecondWithSecond:sender.value];
    
}


#pragma mark slider 松开手指的时候，继续播放
- (IBAction)replay:(UISlider *)sender {
    
    self.dragging = NO;
    
    if (self.isPlaying) {
        [[CZMusicTool sharedCZMusicTool] play];
    }
}

#pragma mark - 播放和暂停

- (void)play{
    [[CZMusicTool sharedCZMusicTool] play];
}

- (void)pause{
    [[CZMusicTool sharedCZMusicTool] pause];
}

#pragma mark 上一首和下一首
-(void)previous{
    if (self.musicIndex == 0) {//第一首
        self.musicIndex = self.musics.count - 1;
    }else{
        self.musicIndex --;
    }
    
    [self playMusic];
}

-(void)next{
    
    //1.更改播放的索引
    if (self.musicIndex == self.musics.count - 1) {//最后条
        self.musicIndex = 0;
    }else{
        self.musicIndex ++;
    }
    
    
    [self playMusic];
}

/**
 *  准备播放音乐
 */
-(void)playMusic{
    
    // 重新初始化一个 "播放器"
    [[CZMusicTool sharedCZMusicTool] prepareToPlayWithMusic:self.musics[self.musicIndex]];
    
    // 更改 “播放器工具条” 的数据
    self.playingMusic = self.musics[self.musicIndex];
    
    // 开始播放
    if (self.isPlaying) {
        [self play];
    }
}

/**
 *  设置当前播放的音乐，并显示数据
 */
-(void)setPlayingMusic:(CZMusic *)playingMusic{
    _playingMusic = playingMusic;
    
    //设置总时间
    double duration = [CZMusicTool sharedCZMusicTool].player.duration;
    self.totalTimeLabel.text = [NSString getMinuteSecondWithSecond:duration];
    
    //设置slider的最大值
    self.timeSlider.maximumValue = duration;
    
    //重置播放时间并更新slider，label
    [CZMusicTool sharedCZMusicTool].player.currentTime = 0;
    [self updateSliderAndTimeLabel];
}

#pragma mark 进度条和时间label
/**
 *  播放中更新进度条和当前播放时间
 */
-(void)update{
    
    if (self.isDragging == NO) {//如果没有拖拽，才需要做下面的操作
        //1.更新进度条
        
        [self updateSliderAndTimeLabel];
    }
}

-(void)updateSliderAndTimeLabel{
    
    double currentTime = [CZMusicTool sharedCZMusicTool].player.currentTime;
    //1.更新进度条
    self.timeSlider.value = currentTime;
    
    //2.更新时间
    self.currentTimeLabel.text = [NSString getMinuteSecondWithSecond:currentTime];
}



#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    // 滚动结束后是第几张ppt，就播放第几首音乐
    self.musicIndex = self.scrollView.contentOffset.x / self.scrollView.width;
    [self playMusic];
}


@end
