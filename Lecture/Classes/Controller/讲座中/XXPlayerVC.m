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
@property (nonatomic, strong) AVPlayerItem *playerItem; // 当前播放的资源

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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self setupPlayerPicView];
    
    [self setupPlayerToolBar];
    
    [XXNotificationCenter addObserver:self selector:@selector(avPlayerItemDidPlayToEndTime:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    // 离开讲座中页面就不能继续播放了，但是按住home键可以进入后台播放
    // 这样也有问题，切换到只看专家的时候也会停止播放
//    self.playing = YES;
//    [self playOrStop];
}

- (void)dealloc{
    [XXNotificationCenter removeObserver:self];
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
    
    if (self.pages.count > 0) {
        // 更改音乐模型
        self.currentPage = self.pages[currentItem];
    }
    
    // 给maskView传递数据，更新当前页码
    self.playerPicView.maskView.currentItem = self.currentItem;
}

#pragma mark - 切换音乐，准备播放音乐，刷新相关控件

- (void)setCurrentPage:(XXXLecturePageModel *)currentPage{
    _currentPage = currentPage;
    
    // 初始化一个 "音频播放器"player，一首音乐对应一个player
    if (self.playerItem) {// 移除上一个item的kvo监听
        [self.playerItem removeObserver:self forKeyPath:@"status"];
    }
    AVPlayer *player = [[AudioTool shareAudioTool] streamPlayerWithURL:currentPage.audio];
    self.player = player;
    self.playerItem = player.currentItem;
    // 添加kvo监听播放器的状态
    [self.playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];// 监听status属性
}

#pragma mark - KVO监听AVplayer的播放状态，是否已经准备就绪
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if (object == _playerItem && [keyPath isEqualToString:@"status"]) {
        if ([_playerItem status] == AVPlayerStatusReadyToPlay) {
            
            // 开始播放
            if (self.isPlaying) {
                [_player play];
            }
            
            // 重置当前播放时间为0
            self.currentDuration = 0;
            
            // 将player传递给playerToolBar
            self.playerToolBar.player = _player;
            
        } else if ([_playerItem status] == AVPlayerStatusFailed) {
            NSLog(@"AVPlayerStatusFailed");
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
-(void)avPlayerItemDidPlayToEndTime:(AVPlayer *)player{
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
    }else{ // 如果没有隐藏
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(hidePlayerToolbar) userInfo:nil repeats:NO];
        self.timer = timer;
    }
}

- (void)hidePlayerToolbar{
    [self addFadeAnimationForView:self.playerToolBar];
    self.playerToolBar.hidden = YES;
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
    // 设置点击返回的url和title
    NSString *url = [NSString stringWithFormat:@"http://lsh.kaimou.net/index.php/Home/Lecture/detail/id/%@?from=groupmessage&isappinstalled=1", self.lectureDetail.lectureId];
    NSString *title = self.lectureDetail.title;
    [UMSocialData defaultData].extConfig.wechatSessionData.url = url;
    [UMSocialData defaultData].extConfig.wechatSessionData.title = title;
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = url;
    [UMSocialData defaultData].extConfig.wechatTimelineData.title = title;
    [UMSocialData defaultData].extConfig.qqData.url = url;
    [UMSocialData defaultData].extConfig.qqData.title = title;
    [UMSocialData defaultData].extConfig.sinaData.urlResource.url = url;
    [UMSocialData defaultData].extConfig.sinaData.snsName = @"医讲堂";
    
    // 跳出分享页面
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:UMKey
                                      shareText:self.lectureDetail.desc
                                     shareImage:[UIImage imageNamed:@"logo"]
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQQ,UMShareToSina,nil]
                                       delegate:nil];
}



@end
