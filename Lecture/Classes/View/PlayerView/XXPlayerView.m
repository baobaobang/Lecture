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

#define PhotoCount 4

@interface XXPlayerView () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *pptView;
@property (weak, nonatomic) IBOutlet UIView *playerToolBar;
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *imageViews;

@property(assign, nonatomic)NSInteger musicIndex;//当前播放音乐索引

@property(strong,nonatomic) NSArray *musics;//音乐数据
@property (weak, nonatomic) IBOutlet UIButton *playBtn;

@end


@implementation XXPlayerView

-(NSArray *)musics{
    if (!_musics) {
        _musics = [CZMusic objectArrayWithFilename:@"songs.plist"];
    }
    
    return _musics;
}

//- (CZMusic *)currentMusic{
//    if (!_currentMusic) {
//        _currentMusic = [[CZMusic alloc] init];
//    }
//    return _currentMusic;
//}

- (IBAction)playBtnClick:(id)sender {
    
    //更改播放状态
    self.playing = !self.playing;
    
    //
    if (self.playing) {//播放音乐
        NSLog(@"播放音乐");
        //1.如果是播放的状态，按钮的图片更改为暂停的状态
        [self.playBtn setNBg:@"playbar_pausebtn_nomal" hBg:@"playbar_pausebtn_click"];
        [self play];
    }else{//暂停音乐
        NSLog(@"暂停音乐");
        //2.如果当前是暂停的状态，按钮的图片更改为播放的状态
        [self.playBtn setNBg:@"playbar_playbtn_nomal" hBg:@"playbar_playbtn_click"];
        [self pause];
    }
    
}

- (void)play{
    [[CZMusicTool sharedCZMusicTool] play];
}

- (void)pause{
    [[CZMusicTool sharedCZMusicTool] pause];
}

+ (instancetype)playerView{
    return [[[NSBundle mainBundle] loadNibNamed:@"XXPlayerView" owner:nil options:nil] lastObject];
}



- (void)awakeFromNib{
    
    // 1.创建一个scrollView：用于显示所有的ppt图片
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    [self.pptView addSubview:scrollView];
    self.scrollView = scrollView;


    // 2.添加图片到scrollView中
    for (int i = 0; i < PhotoCount; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        NSString *name = [NSString stringWithFormat:@"new_feature_%d", i + 1];
        imageView.image = [UIImage imageNamed:name];
        [self.scrollView addSubview:imageView];
    }
    
    // 3.设置scrollView的其他属性
    // 如果想要某个方向上不能滚动，那么这个方向对应的尺寸数值传0即可
    scrollView.bounces = NO; // 去除弹簧效果
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.delegate = self;
    
    //2.重新初始化一个 "播放器"
    [self playMusic];
    
}

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
    for (int i = 0; i<PhotoCount; i++) {
        //TODO:imageView的创建应该放到awakeFromNib中
        UIImageView *imageView = self.scrollView.subviews[i];
        imageView.width = scrollW;
        imageView.height = scrollH;
        imageView.y = 0;
        imageView.x = i * scrollW;
    }
    
    // 设置scrollView的contentSize
    self.scrollView.contentSize = CGSizeMake(PhotoCount * scrollW, 0);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
}

#pragma mark 播放上一首
-(void)previous{
    if (self.musicIndex == 0) {//第一首
        self.musicIndex = self.musics.count - 1;
    }else{
        self.musicIndex --;
    }
    
    [self playMusic];
}

#pragma mark 播放下一首
-(void)next{
    
    //1.更改播放的索引
    if (self.musicIndex == self.musics.count - 1) {//最后条
        self.musicIndex = 0;
    }else{
        self.musicIndex ++;
    }
    
    
    [self playMusic];
}


-(void)playMusic{
    
    //2.重新初始化一个 "播放器"
    [[CZMusicTool sharedCZMusicTool] prepareToPlayWithMusic:self.musics[self.musicIndex]];
    
    //3.更改 “播放器工具条” 的数据
    self.playingMusic = self.musics[self.musicIndex];
    
    //4.播放
    if (self.isPlaying) {
        [self play];
    }
    
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    // 滚动结束后是第几张ppt，就播放第几首音乐
    self.musicIndex = self.scrollView.contentOffset.x / self.scrollView.width;
    [self playMusic];
    
}


@end
