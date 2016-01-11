//
//  XXPlayerView.m
//  Lecture
//
//  Created by 陈旭 on 16/1/7.
//  Copyright © 2016年 陈旭. All rights reserved.
//

#import "XXPlayerView.h"
#import "MJExtension.h"
#import "UIButton+CZ.h"
#import "HMCollectionCell.h"
#import <AVFoundation/AVFoundation.h>
#import "HMMusic.h"

#define PlayerCurrentTimeKeyPath @"currentTime"
#define HMMaxSections 3

@interface XXPlayerView () <UICollectionViewDataSource, UICollectionViewDelegate, AVAudioPlayerDelegate>

/** pptView */
@property (weak, nonatomic) IBOutlet UIView *pptView;
/** playerToolBar */
@property (weak, nonatomic) IBOutlet UIView *playerToolBar;
/** 放滚动图片的collectionView */
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
/** 当前显示的item索引 */
@property(assign, nonatomic) NSInteger currentItem;

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
/** 是否正在拖拽 */
@property(assign,nonatomic,getter=isDragging)BOOL dragging;
/** 播放器 */
@property(nonatomic,strong)AVAudioPlayer *player;
/** 定时器 */
@property(strong,nonatomic)CADisplayLink *link;
/** 蒙版 */
@property (weak, nonatomic) IBOutlet UIView *maskView;
/** 页码标签 */
@property (weak, nonatomic) IBOutlet UILabel *pageNumberLabel;

@end


@implementation XXPlayerView

#pragma mark - 懒加载

-(NSArray *)musics{
    
    if (!_musics) {
        _musics = [HMMusic objectArrayWithFilename:@"Musics.plist"];
    }
    
    return _musics;
}

-(CADisplayLink *)link{
    if (!_link) {
        _link = [CADisplayLink displayLinkWithTarget:self selector:@selector(currentTimeUpdate)];
    }
    
    return _link;
}

#pragma mark - 生命周期

-(void)dealloc{
    

    //移除定时器
    [self.link removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
}

#pragma mark - 初始化

- (void)awakeFromNib{
    
    // 设置pptView
    [self setupPptView];
    
    // 设置playerToolBar
    [self setupPlayerToolBar];
    
    // 设置显示的item索引，即要播放的音乐
    self.currentItem = 0;
    
    // 默认显示最中间的那组--这里必须要延迟，否则不会执行
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self scrollToMiddleSectionWithoutAnimation];
    });
    
    // 开启定时器
    [self.link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

+ (instancetype)playerView{
    return [[[NSBundle mainBundle] loadNibNamed:@"XXPlayerView" owner:nil options:nil] lastObject];
}

/**
 *  设置pptView
 */
- (void)setupPptView{
    
    // 注册collectionView的cell
    [self.collectionView registerNib:[UINib nibWithNibName:@"HMCollectionCell" bundle:nil] forCellWithReuseIdentifier:HMCollectionViewCellIdentifier];
    
    // 向collectionView添加单击手势
    UITapGestureRecognizer *collectionViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playBtnClick)];
    collectionViewTap.numberOfTapsRequired = 1;
    [self.collectionView addGestureRecognizer:collectionViewTap];
    
    // 向maskView添加单击手势
    UITapGestureRecognizer *maskViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playBtnClick)];
    maskViewTap.numberOfTapsRequired = 1;
    [self.maskView addGestureRecognizer:maskViewTap];
    
}

/**
 *  设置playerToolBar
 */
- (void)setupPlayerToolBar{
    
    self.playerToolBar.backgroundColor = HWColor(38, 38, 38);
    
    // 设置slider 按钮的图片
    UIImage *originSliderImage = [UIImage imageNamed:@"playbar_slider_thumb"];
    UIImage *scaledSliderImage = [UIImage originImage:originSliderImage scaleToSize:CGSizeMake(PlayerToolBarHeight, PlayerToolBarHeight)];
    [self.timeSlider setThumbImage:scaledSliderImage forState:UIControlStateNormal];
}

#pragma mark - 更改播放音乐的索引

- (void)setCurrentItem:(NSInteger)currentItem{
    // 更新索引
    _currentItem = currentItem;
    
    // 更改音乐模型
    self.currentMusic = self.musics[currentItem];
    
    // 设置页码标签
    self.pageNumberLabel.text = [NSString stringWithFormat:@"第%ld/%ld页", currentItem + 1, self.musics.count];
}

#pragma mark - 切换音乐，准备播放音乐，刷新相关控件

- (void)setCurrentMusic:(HMMusic *)currentMusic{
    _currentMusic = currentMusic;
    
    // 初始化一个 "音频播放器"player，一首音乐对应一个player
    NSURL *musicURL = [[NSBundle mainBundle] URLForResource:currentMusic.filename withExtension:nil];
    AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:musicURL error:nil];
    
    // 准备
    [player prepareToPlay];
    
    // 设置player的代理
    player.delegate = self;
    
    // 设置音乐总时长
    double duration = player.duration;
    self.totalTimeLabel.text = [NSString getMinuteSecondWithSecond:duration];
    
    // 设置slider的最大值
    self.timeSlider.maximumValue = duration;
    
    // 重置当前播放时间为0
    player.currentTime = 0;
    
    // 开始播放
    if (self.isPlaying) {
        [player play];
    }
    
    //
    self.player = player;
}

#pragma mark - currentTime属性变化之后，刷新进度条和currentTimeLabel
- (void)currentTimeUpdate{
    
    if (self.isDragging == NO){
        // 如果没有在拖拽进度条，就根据currentTime更新进度条
        self.timeSlider.value = self.player.currentTime;
    }
    //2.更新当前时间
    self.currentTimeLabel.text = [NSString getMinuteSecondWithSecond:self.player.currentTime];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.musics.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 创建可重用的cell
    HMCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:HMCollectionViewCellIdentifier forIndexPath:indexPath];
    
    // 设置cell的数据
    cell.music = self.musics[indexPath.item];
    cell.backgroundColor = HWTestColor;

    return cell;
}

#pragma mark - 播放和暂停

- (IBAction)playBtnClick{
    
    //更改播放状态
    self.playing = !self.playing;
    //
    if (self.playing) {//播放音乐
        //1.如果是播放的状态，按钮的图片更改为暂停的状态
        [self.playBtn setNBg:@"playbar_pausebtn_nomal" hBg:@"playbar_pausebtn_click"];
        [self.player play];

        [self addFadeAnimation];
        self.maskView.hidden = YES;
        
    }else{//暂停音乐
        //2.如果当前是暂停的状态，按钮的图片更改为播放的状态
        [self.playBtn setNBg:@"playbar_playbtn_nomal" hBg:@"playbar_playbtn_click"];
        [self.player pause];
        
        [self addFadeAnimation];
        self.maskView.hidden = NO;
    }
}

/**
 *  在maskView隐藏和显现的时候添加动画效果
 */
- (void)addFadeAnimation{
    CATransition *animation = [CATransition animation];
    animation.type = kCATransitionFade;
    animation.duration = 0.4;
    [self.maskView.layer addAnimation:animation forKey:nil];
}

#pragma mark 点击slider的时候，暂停播放

- (IBAction)stopPlay:(UISlider *)sender {
    //更改拖拽的状态
    self.dragging = YES;
    
    [self.player pause];
}

#pragma mark 拖动slider的时候，更新播放时间

- (IBAction)sliderChange:(UISlider *)sender {
    
    self.player.currentTime = sender.value;
}

#pragma mark 手指离开slider的时候，继续播放

- (IBAction)replay:(UISlider *)sender {
    
    self.dragging = NO;
    
    if (self.isPlaying) { // 拖动前如果是播放状态，拖动后就继续播放
        [self.player play];
    }
}


// 更改索引会自动切换音乐，滚动的范围是从section0的最后一首到section2的第一首
#pragma mark 上一首

-(void)previous{
    
    if (self.currentItem == 0) { // 当前是第一首，需要切换section
        // 先无动画滚到section2的第一首
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentItem inSection:2] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
        // 更改索引为最后一首
        self.currentItem = self.musics.count - 1;
        
    }else{ // 当前不是第一首，不需要切换section
        // 更改索引为上一首
        self.currentItem --;
    }
    
    // 有动画滚回到中间那组的对应currentItem的位置
    [self scrollToMiddleSectionWithAnimation];
}

#pragma mark 下一首

-(void)next{
    
    if (self.currentItem == self.musics.count - 1) { // 当前是最后一首，需要切换section
        // 先无动画滚到section0的最后一首
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentItem inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
        // 更改索引为第一首
        self.currentItem = 0;
        
    }else{ // 当前不是最后一首，不需要切换section
        // 更改索引为下一首
        self.currentItem ++;
    }
    
    // 有动画滚回到中间那组的对应currentItem的位置
    [self scrollToMiddleSectionWithAnimation];
}

#pragma mark - 无动画滚回到中间那组的对应currentItem的位置

- (void)scrollToMiddleSectionWithoutAnimation{
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentItem inSection:1] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
}
#pragma mark - 有动画滚回到中间那组的对应currentItem的位置

- (void)scrollToMiddleSectionWithAnimation{
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentItem inSection:1] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
}


#pragma mark - 滚动图片切换到另一张后自动切换音乐

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    // 滚动结束后，屏幕上正显示的cell的索引数组，有时候里面有一个对象，有时候是两个对象
    NSArray *array = [self.collectionView indexPathsForVisibleItems];
    NSIndexPath *firstIndexPath = [array firstObject];
    NSIndexPath *lastIndexPath = [array lastObject];
    
    // 如果索引为新，就变更索引
    NSInteger section = 0;
    if (self.currentItem != firstIndexPath.item ){
        self.currentItem = firstIndexPath.item;
        section = firstIndexPath.section;
    }else {
        self.currentItem = lastIndexPath.item;
        section = lastIndexPath.section;
    }
    
    // 如果section不是1，就无动画滚动到section1的位置
    if (section != 1) {
        [self scrollToMiddleSectionWithoutAnimation];
    }
}

#pragma mark 自动播放下一首
-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    //自动播放下一首
    [self next];
}


#pragma mark 蒙版按钮点击

- (IBAction)previousBtnClick:(id)sender {
    [self previous];
}

- (IBAction)nextBtnClick:(id)sender {
    [self next];
}

/**
 *  点击分享按钮
 */
- (IBAction)shareBtnClick:(id)sender {

}



@end
