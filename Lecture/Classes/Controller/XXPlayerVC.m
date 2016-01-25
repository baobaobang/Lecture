//
//  XXPlayerVC.m
//  Lecture
//
//  Created by 陈旭 on 16/1/20.
//  Copyright © 2016年 陈旭. All rights reserved.
//

#import "XXPlayerVC.h"
#import "XXPlayerToolBar.h"
#import <AVFoundation/AVFoundation.h>
#import "UIButton+CZ.h"
#import "XXCollectionCell.h"
#import "XXMusic.h"
#import "MBProgressHUD.h"
#import <MJExtension.h>

#define PlayerCurrentTimeKeyPath @"currentTime"
#define XXMaxSections 3

@interface XXPlayerVC ()<AVAudioPlayerDelegate, XXPlayerToolBarDelegate, XXPlayerPicViewDelegate, XXPlayerMaskViewDelegate>

@property (nonatomic, weak) XXPlayerToolBar *playerToolBar;
/** 播放器 */
@property(nonatomic,strong)AVAudioPlayer *player;

/** 当前显示的item索引 */
@property(assign, nonatomic) NSInteger currentItem;

/** 音乐数据 */
@property(strong,nonatomic) NSArray *musics;
@end

@implementation XXPlayerVC


#pragma mark - 懒加载

-(NSArray *)musics{
    
    if (!_musics) {
        _musics = [XXMusic objectArrayWithFilename:@"Musics.plist"];
    }
    
    return _musics;
}

#pragma mark - 生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupPlayerPicView];
    
    [self setupPlayerToolBar];
    
    // 设置显示的item索引，即要播放的音乐
    self.currentItem = 0;
}



#pragma mark - 初始化

- (void)setupPlayerPicView
{
    // 创建playerPicView
    XXPlayerPicView *playerPicView = [[XXPlayerPicView alloc] init];
    playerPicView.x = 0;
    playerPicView.y = 0;
    playerPicView.width = self.view.width;
    playerPicView.height = XXPlayerPicViewHeightWidthRatio * playerPicView.width;
    playerPicView.musics = self.musics;
    playerPicView.delegate = self;
    [self.view addSubview:playerPicView];
    self.playerPicView = playerPicView;
    
    // 设置maskView的代理
    playerPicView.maskView.delegate = self;
    // 给maskView传递数据
    playerPicView.maskView.currentItem = self.currentItem;
    playerPicView.maskView.musics = self.musics;
}

- (void)setupPlayerToolBar
{
    // 创建playerToolBar
    XXPlayerToolBar *playerToolBar = [[XXPlayerToolBar alloc] init];
    playerToolBar.x = 0;
    playerToolBar.y = CGRectGetMaxY(self.playerPicView.frame);
    playerToolBar.width = self.view.width;
    playerToolBar.height = 30;
    playerToolBar.backgroundColor = XXColor(38, 38, 38);
    playerToolBar.delegate = self;
    [self.view addSubview:playerToolBar];
    self.playerToolBar = playerToolBar;
    
    // 设置self.view的高度，它是由子view的高度来决定的
    self.view.height = self.playerPicView.height + self.playerToolBar.height;
    
    // 设置slider 按钮的图片
    UIImage *originSliderImage = [UIImage imageNamed:@"playbar_slider_thumb"];
    UIImage *scaledSliderImage = [originSliderImage imageScaleToSize:CGSizeMake(PlayerToolBarHeight, PlayerToolBarHeight)];
    [playerToolBar.timeSlider setThumbImage:scaledSliderImage forState:UIControlStateNormal];
}


#pragma mark - 更改播放音乐的索引

- (void)setCurrentItem:(NSInteger)currentItem{
    // 更新索引
    _currentItem = currentItem;
    
    // 更改音乐模型
    self.currentMusic = self.musics[currentItem];
    
    // 给maskView传递数据，更新当前页码
    self.playerPicView.maskView.currentItem = self.currentItem;
}

#pragma mark - 切换音乐，准备播放音乐，刷新相关控件

- (void)setCurrentMusic:(XXMusic *)currentMusic{
    _currentMusic = currentMusic;
    
    // 初始化一个 "音频播放器"player，一首音乐对应一个player
    NSURL *musicURL = [[NSBundle mainBundle] URLForResource:currentMusic.filename withExtension:nil];
    AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:musicURL error:nil];
    
    // 准备
    [player prepareToPlay];
    
    // 设置player的代理
    player.delegate = self;
    
    // 开始播放
    if (self.isPlaying) {
        [player play];
    }
    
    // 重置当前播放时间为0
    player.currentTime = 0;
    
    //
    self.player = player;
    
    // 将player传递给playerToolBar
    self.playerToolBar.player = player;
}

#pragma mark - 播放或者暂停

- (void)playOrStop{
    //更改播放状态
    self.playing = !self.playing;
    
    if (self.playing) {//播放音乐
        //1.如果是播放的状态，按钮的图片更改为暂停的状态
        [self.playerToolBar.playBtn setNBg:@"playbar_pausebtn_nomal" hBg:@"playbar_pausebtn_click"];
        [self.player play];
        
        [self addFadeAnimation];
        self.playerPicView.maskView.hidden = YES;
        
    }else{//暂停音乐
        //2.如果当前是暂停的状态，按钮的图片更改为播放的状态
        [self.playerToolBar
         .playBtn  setNBg:@"playbar_playbtn_nomal" hBg:@"playbar_playbtn_click"];
        [self.player pause];
        
        [self addFadeAnimation];
        self.playerPicView.maskView.hidden = NO;
    }
}


// 更改索引会自动切换音乐，滚动的范围是从section0的最后一首到section2的第一首
#pragma mark - 上一首

-(void)previous{
    
    if (self.currentItem == 0){ // 如果是第一首
        [self showHudWithMessage:@"已经是第一首了"];
    }else{
        
        // 当前不是第一首，就更改索引为上一首
        self.currentItem --;
        
        // 有动画滚动到对应currentItem的位置
        [self scrollToItemWithAnimation:self.currentItem];
    }
}

#pragma mark - 下一首

-(void)next{
    
    if (self.currentItem == self.musics.count - 1) { // 如果是最后一首
        [self showHudWithMessage:@"已经是最后一首了"];
        
    }else{
        // 当前不是最后一首，更改索引为下一首
        self.currentItem ++;
        
        // 有动画滚动到对应currentItem的位置
        [self scrollToItemWithAnimation:self.currentItem];
    }
}

- (void)showHudWithMessage:(NSString *)message{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.playerPicView animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = message;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:1];
}

#pragma mark - 有动画滚动到对应currentItem的位置

- (void)scrollToItemWithAnimation:(NSUInteger)item{
    [self.playerPicView.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:item inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
}

#pragma mark - 自动播放下一首
-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    //自动播放下一首
    [self next];
}

#pragma mark - XXPlayerPicViewDelegate
#pragma mark - 点击maskView
- (void)playerPicView:(XXPlayerPicView *)playerPicView didClickPlayerMaskView:(XXPlayerMaskView *)maskView{
    
    [self playOrStop];
}
#pragma mark - 点击collectionView
- (void)playerPicView:(XXPlayerPicView *)playerPicView didClickCollectionView:(UICollectionView *)collectionView{
    
    [self playOrStop];
}

#pragma mark - 滚动图片切换到另一张后自动切换音乐

- (void)playerPicView:(XXPlayerPicView *)playerPicView collectionViewDidEndDecelerating:(UICollectionView *)collectionView{
    
    // 滚动结束后，屏幕上正显示的cell的索引数组，有时候里面有一个对象，有时候是两个对象
    NSArray *array = [collectionView indexPathsForVisibleItems];
    NSIndexPath *firstIndexPath = [array firstObject];
    NSIndexPath *lastIndexPath = [array lastObject];
    
    // 如果索引为新，就变更索引
    if (self.currentItem != firstIndexPath.item ){
        self.currentItem = firstIndexPath.item;
    }else {
        self.currentItem = lastIndexPath.item;
    }
}

#pragma mark - XXPlayerToolBarDelegate 控制slider

- (void)playerToolBar:(XXPlayerToolBar *)toolBar didClickPlayBtn:(UIButton *)btn{
    [self playOrStop];
}

// 在maskView隐藏和显现的时候添加动画效果

- (void)addFadeAnimation{
    CATransition *animation = [CATransition animation];
    animation.type = kCATransitionFade;
    animation.duration = 0.4;
    [self.playerPicView.maskView.layer addAnimation:animation forKey:nil];
}

// 点击slider的时候，暂停播放

- (void)playerToolBar:(XXPlayerToolBar *)toolBar didBeginDraggingSlider:(UISlider *)slider{
    //更改拖拽的状态
    toolBar.dragging = YES;
    
    [self.player pause];
}

// 拖动slider的时候，更新播放时间

- (void)playerToolBar:(XXPlayerToolBar *)toolBar sliderValueChanged:(UISlider *)slider{
    
    self.player.currentTime = slider.value;
}

// 手指离开slider的时候，继续播放

- (void)playerToolBar:(XXPlayerToolBar *)toolBar didStopDraggingSlider:(UISlider *)slider{
    
    toolBar.dragging = NO;
    
    if (self.isPlaying) { // 拖动前如果是播放状态，拖动后就继续播放
        [self.player play];
    }
}

#pragma mark - XXPlayerMaskViewDelegate 蒙版按钮点击

- (void)playerMaskView:(XXPlayerMaskView *)playerMaskView didClickBtnType:(XXPlayerMaskViewButtonType)type{
    switch (type) {
        case XXPlayerMaskViewButtonTypeShare:
            
            break;
        case XXPlayerMaskViewButtonTypePrevious:
            [self previous];
            break;
        case XXPlayerMaskViewButtonTypePlay:
            [self playOrStop];
            break;
        case XXPlayerMaskViewButtonTypeNext:
            [self next];
            break;
            
        default:
            break;
    }
}

@end
