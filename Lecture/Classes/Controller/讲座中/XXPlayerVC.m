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
#import "XXXLecturePageModel.h"
#import "MBProgressHUD.h"
#import "MJExtension.h"
#import "AudioTool.h"
#import <UMSocial.h>

#define PlayerCurrentTimeKeyPath @"currentTime"
#define XXMaxSections 3

@interface XXPlayerVC ()<AVAudioPlayerDelegate, XXPlayerToolBarDelegate, XXPlayerPicViewDelegate, XXPlayerMaskViewDelegate>

@property (nonatomic, weak) XXPlayerToolBar *playerToolBar;
/** 播放器 */
//@property(nonatomic,strong)AVAudioPlayer *player; // 只能播放本地音频
@property (nonatomic, strong) AVPlayer *player; // 可播放本地和网络音频的播放器
@property (nonatomic, weak) AVPlayerItem *playerItem; // 当前播放的资源

@property (nonatomic, assign) CGFloat currentDuration; // 当前播放时间
@property (nonatomic, assign) CGFloat totalDuration; // 播放总时间
/** 当前显示的item索引 */
@property(assign, nonatomic) NSInteger currentItem;

/** 音乐数据 */
@property(strong,nonatomic) NSArray *pages;

@property (nonatomic, strong) NSTimer *timer;
@end

@implementation XXPlayerVC


#pragma mark - 懒加载

#pragma mark - 生命周期

- (void)dealloc{
    [XXNotificationCenter removeObserver:self];

    [self.player replaceCurrentItemWithPlayerItem:nil];
    [self.player pause];// 暂停讲座的音频
    [[AudioTool shareAudioTool].streamPlayer pause];// 暂停回复的音频

    [self.playerItem removeObserver:self forKeyPath:@"status"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self setupPlayerPicView];
    
    [self setupPlayerToolBar];
    
    // 播放完一首后
    [XXNotificationCenter addObserver:self selector:@selector(endPlay) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    // 分享失败后
    [XXNotificationCenter addObserver:self selector:@selector(shareFail) name:XXShareFailNotification object:nil];
    // 分享失败后
    [XXNotificationCenter addObserver:self selector:@selector(shareSuccess) name:XXShareSuccessNotification object:nil];
    
    // 观察拔出耳机时候暂停播放音乐
    [XXNotificationCenter addObserver:self selector:@selector(unpluggedEarPhone) name:NOTIFICATION_HEADESTUNPLUGGED object:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self.timer invalidate];
    self.timer = nil;
}


#pragma mark - 传递lecture详情数据给PlayerPicView和PlayerToolBar
- (void)setLectureDetail:(XXXLectureModel *)lectureDetail{
    
    _lectureDetail = lectureDetail;
    
    self.pages = lectureDetail.pages;
    self.playerPicView.pages = lectureDetail.pages;
    
    // 设置进入时候播放第一首音乐
    self.currentItem = 0;
    
    // 给maskView传递数据
    self.playerPicView.maskView.pages = self.pages;
}

#pragma mark - 初始化

- (void)setupPlayerPicView
{
    // 创建playerPicView
    XXPlayerPicView *playerPicView = [[XXPlayerPicView alloc] init];
    playerPicView.delegate = self;
    [self.view addSubview:playerPicView];
    self.playerPicView = playerPicView;
    
    // 设置maskView的代理
    playerPicView.maskView.delegate = self;
    
    // 设置音频会话类型
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    [session setActive:YES error:nil];
}

- (void)setupPlayerToolBar
{
    // 创建playerToolBar
    XXPlayerToolBar *playerToolBar = [[XXPlayerToolBar alloc] init];
    playerToolBar.backgroundColor = [UIColor colorWithWhite:0.4 alpha:0.7];
    playerToolBar.delegate = self;
    [self.view addSubview:playerToolBar];
    self.playerToolBar = playerToolBar;
}

#pragma mark - 重新布局
- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];

    // 如果横屏就不要重新布局子控件
    NSLog(@"%@", NSStringFromCGRect(self.view.frame));
    if (self.view.height == XXScreenHeight) return;
    
    // 这里只能在第一次加载页面和横竖屏切换的时候调用，否则子控件布局会出问题
    [self setupPlayerToolBarFrame];
    [self setupPlayerPicViewFrame];
}

- (void)setupPlayerToolBarFrame{
    
    _playerToolBar.x = 0;
    _playerToolBar.height = kXXPlayerToolBarHeight;
    _playerToolBar.width = self.view.width;
    _playerToolBar.y = self.view.height - _playerToolBar.height;
}

- (void)setupPlayerPicViewFrame{
    
    _playerPicView.x = 0;
    _playerPicView.y = 0;
    _playerPicView.width = self.view.width;
    _playerPicView.height = self.view.height;
}

#pragma mark - 更改播放音乐的索引

- (void)setCurrentItem:(NSInteger)currentItem{
    // 更新索引
    _currentItem = currentItem;
    
    // 给maskView传递数据，更新当前页码
    self.playerPicView.maskView.currentItem = self.currentItem;
    
    if (self.pages.count <= 0) return;
    
    self.currentPage = self.pages[currentItem];
    
    if (currentItem == XXSharePageNumber && !UserDefaultsGet(self.lectureDetail.lectureId)) {
        // 如果用户没有分享过就出分享接力页面
        [self showShareToWechatTimeline];
        self.playing = YES;
        [self playOrStop];
    }
}

#pragma mark - 切换音乐，准备播放音乐，刷新相关控件

- (void)setCurrentPage:(XXXLecturePageModel *)currentPage{
    _currentPage = currentPage;
    
    // 初始化一个 "音频播放器"player，一首音乐对应一个player
    if (self.playerItem) {// 移除上一个item的kvo监听
        [self.playerItem removeObserver:self forKeyPath:@"status"];
    }
    AVPlayer *player = [[AudioTool shareAudioTool] noSinglePlayerWithURL:currentPage.audio];
    self.player = player;
    self.playerItem = player.currentItem;
    
    // 横屏后切换下一页时不能重新布局，否则子控件的布局会出错，因此viewWillLayoutSubviews在切换下一页的时候，不应该再被调用，因此不能再添加子控件，比如将hud添加到self.view上
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    // 添加kvo监听播放器的状态
    [self.playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];// 监听status属性
}



#pragma mark - 分享到朋友圈
// 展现分享页面
- (void)showShareToWechatTimeline
{
    [XXNotificationCenter postNotificationName:showShareView object:nil];
}

// 分享失败后返回上一首
- (void)shareFail{
    [self previous];
}

// 分享成功后来到下一首
- (void)shareSuccess{
    [self next];
}

#pragma mark - KVO监听AVplayer的播放状态，是否已经准备就绪
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if (object == _playerItem && [keyPath isEqualToString:@"status"]) {
        if ([_playerItem status] == AVPlayerStatusReadyToPlay) {
            // 开始播放
            NSLog(@"%@", NSStringFromCGRect(self.view.frame));
            NSLog(@"%@", NSStringFromCGRect(self.view.maskView.frame));
            if (self.isPlaying) {
                [_player play];
            }
            
            // 重置当前播放时间为0
            self.currentDuration = 0;
            
            // 将player传递给playerToolBar
            self.playerToolBar.player = _player;
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
        } else if ([_playerItem status] == AVPlayerStatusFailed) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [MBProgressHUD showError:@"讲座音频加载失败" toView:self.view];
        }
    }
}

#pragma mark - 播放或者暂停

- (void)playOrStop{
    //更改播放状态
    self.playing = !self.playing;
    
    if (self.playing) {//播放音乐
        //1.如果是播放的状态，按钮的图片更改为暂停的状态
        self.playerToolBar.playBtn.selected = YES;
        [self.player play];
        
        [self addFadeAnimationForView:self.playerPicView.maskView];
        self.playerPicView.maskView.hidden = YES;
        [self addFadeAnimationForView:self.playerToolBar];
        self.playerToolBar.hidden = YES;
        // 隐藏导航栏
//        [XXNotificationCenter postNotificationName:XXStartPlayingNotification object:nil];
        
    }else{//暂停音乐
        //2.如果当前是暂停的状态，按钮的图片更改为播放的状态
        self.playerToolBar.playBtn.selected = NO;
        [self.player pause];
        
        [self addFadeAnimationForView:self.playerPicView.maskView];
        self.playerPicView.maskView.hidden = NO;
        [self addFadeAnimationForView:self.playerToolBar];
        self.playerToolBar.hidden = NO;
        [self.timer invalidate]; // 暂停播放的时候就一直显示播放条
        self.timer = nil;
        // 显示导航栏
//        [XXNotificationCenter postNotificationName:XXStopPlayingNotification object:nil];
    }
}


// 更改索引会自动切换音乐，滚动的范围是从section0的最后一首到section2的第一首
#pragma mark - 上一首

-(void)previous{
    if (self.pages == nil) {// 网络不好的情况
        [self showHudWithMessage:@"暂无数据。。。"];
    }else{
        if (self.currentItem == 0){ // 如果是第一首
            [self showHudWithMessage:@"已经是第一页了"];
        }else{
            
            // 当前不是第一首，就更改索引为上一首
            self.currentItem --;
            
            // 有动画滚动到对应currentItem的位置
            [self scrollToItemWithAnimation:self.currentItem];
        }
    }
}


- (void)showHudWithMessage:(NSString *)message{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.playerPicView animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = message;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:1];
}

#pragma mark - 下一首

-(void)next{
    
    if (self.pages == nil) {// 网络不好的情况
        [self showHudWithMessage:@"暂无数据。。。"];
    }else{
        if (self.currentItem == self.pages.count - 1) { // 如果是最后一首
            [self showHudWithMessage:@"已经是最后一页了"];
            
        }else{
            // 当前不是最后一首，更改索引为下一首
            self.currentItem ++;
            
            // 有动画滚动到对应currentItem的位置
            [self scrollToItemWithAnimation:self.currentItem];
        }
    }

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

#pragma mark - 有动画滚动到对应currentItem的位置

- (void)scrollToItemWithAnimation:(NSUInteger)item{
    
    [self.playerPicView.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:item inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
}

#pragma mark - 自动播放下一首
-(void)endPlay{
    //自动播放下一首
    [self next];
}

#pragma mark - XXPlayerPicViewDelegate
#pragma mark - 点击maskView
- (void)playerPicView:(XXPlayerPicView *)playerPicView didClickPlayerMaskView:(XXPlayerMaskView *)maskView{
    
//    [self playOrStop];
}
#pragma mark - 点击collectionView
- (void)playerPicView:(XXPlayerPicView *)playerPicView didClickCollectionView:(UICollectionView *)collectionView{
    
    [self addFadeAnimationForView:self.playerToolBar];
    self.playerToolBar.hidden = !self.playerToolBar.hidden;
    
    if (self.playerToolBar.hidden) { // 如果已经隐藏
        [self.timer invalidate];
        self.timer = nil;
    }else{ // 如果没有隐藏
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(hidePlayerToolbar) userInfo:nil repeats:NO];
        self.timer = timer;
    }
}

- (void)hidePlayerToolbar{
    [self addFadeAnimationForView:self.playerToolBar];
    self.playerToolBar.hidden = YES;
}

#pragma mark - XXPlayerToolBarDelegate 控制slider

- (void)playerToolBar:(XXPlayerToolBar *)toolBar didClickPlayBtn:(UIButton *)btn{
    [self playOrStop];
}

// 在maskView隐藏和显现的时候添加动画效果

- (void)addFadeAnimationForView:(UIView *)view{
    CATransition *animation = [CATransition animation];
    animation.type = kCATransitionFade;
    animation.duration = 0.4;
    [view.layer addAnimation:animation forKey:nil];
}

// 点击slider的时候，暂停播放

- (void)playerToolBar:(XXPlayerToolBar *)toolBar didBeginDraggingSlider:(UISlider *)slider{
    //更改拖拽的状态
    toolBar.dragging = YES;
    
    [self.player pause];
}

// 拖动slider的时候，更新播放时间

- (void)playerToolBar:(XXPlayerToolBar *)toolBar sliderValueChanged:(UISlider *)slider
{
    self.currentDuration = slider.value;
    CMTime currentTime = CMTimeMake(slider.value, 1);
    [self.player seekToTime:currentTime];
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
            [self share];
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

#pragma mark - 分享页面
- (void)share{
    [XXNotificationCenter postNotificationName:XXPlayerShareNotification object:nil];
}

- (void)unpluggedEarPhone{
    self.playing = YES;
    [self playOrStop];
}



@end
