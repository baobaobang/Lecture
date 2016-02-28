//
//  XXQuestionReplyCell.m
//  Lecture
//
//  Created by 陈旭 on 16/1/28.
//  Copyright © 2016年 陈旭. All rights reserved.
//

#import "XXQuestionReplyCell.h"
#import "AudioTool.h"


@interface XXQuestionReplyCell ()<AVAudioPlayerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet XXButton *playBtn;
@property (weak, nonatomic) IBOutlet UILabel *totalTimeLabel;
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerItem *playerItem;
@property (nonatomic, assign, getter=isPlaying) BOOL playing;
@end

@implementation XXQuestionReplyCell
#pragma mark - 生命周期

-(void)dealloc{
    [XXNotificationCenter removeObserver:self];
//    self.player = nil;
//    self.playerItem = nil;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.userNameLabel.font = XXQuestionCellReplyFont;
    self.userNameLabel.numberOfLines = 0;
    self.userNameLabel.textColor = [UIColor orangeColor];
    self.userNameLabel.text = @"";
    
    [self setupPlayBtn];
    
    self.totalTimeLabel.font = XXQuestionCellReplyTimeFont;
    self.totalTimeLabel.numberOfLines = 0;
    self.totalTimeLabel.textColor = [UIColor darkGrayColor];
    self.totalTimeLabel.text = @"";

}

- (void)setupPlayBtn{
    self.playBtn.enabled = NO;
    [self.playBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.playBtn setBackgroundColor:[UIColor whiteColor]];
    
    // UIImageView连续播放图片,组成动画 增加一个喇叭动态的效果
    // imageWithRenderingMode是为了改变图片的颜色
    UIImageView *animationView = self.playBtn.imageView;
    UIColor *tintColor = [UIColor orangeColor];
    animationView.animationImages = [NSArray arrayWithObjects:
                                     [[UIImage imageNamed:@"1.png"] imageWithTintColor:tintColor],
                                     [[UIImage imageNamed:@"2.png"] imageWithTintColor:tintColor],
                                     [[UIImage imageNamed:@"3.png"] imageWithTintColor:tintColor], nil];
    animationView.animationDuration = 1.5;
    animationView.animationRepeatCount = 0;
    
    
    [XXNotificationCenter addObserver:self selector:@selector(avPlayerItemDidPlayToEndTime:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}

- (void)setReply:(XXReply *)reply{
    _reply = reply;
    
    self.userNameLabel.text = [NSString stringWithFormat:@"%@:", reply.nickName];
    [self setupTotalTimeLabel:reply];
}

- (void)setupTotalTimeLabel:(XXReply *)reply{
    // 初始化一个 "音频播放器"player，一首音乐对应一个player
    AVPlayer *player = [[AudioTool shareAudioTool] streamPlayerWithURL:reply.content];
    self.player = player;
    AVPlayerItem *playerItem = player.currentItem;
    self.playerItem = playerItem;
    
    // 添加kvo监听播放器的状态
    [playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];// 监听status属性
}

#pragma mark - KVO监听AVplayer的播放状态，是否已经准备就绪
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if (object == _playerItem && [keyPath isEqualToString:@"status"]) {
        if ([_playerItem status] == AVPlayerStatusReadyToPlay) {// 准备就绪后
            // 设置默认显示总时长
            CMTime totalTime = self.playerItem.duration;
            CGFloat duration = (CGFloat)totalTime.value/totalTime.timescale;
            self.totalTimeLabel.text = [NSString wechatTime:duration];
            
            self.playBtn.enabled = YES;
            // 移除kvo监听
            [self.playerItem removeObserver:self forKeyPath:@"status"];
            
        } else if ([_playerItem status] == AVPlayerStatusFailed) {
            self.playBtn.enabled = NO;
        }
    }
}

#pragma mark - 点击播放按钮
- (IBAction)clickPlayBtn:(XXButton *)btn {
    
    if (self.reply == nil) return;
    
    self.playing = !self.playing;
    if (self.playing) { // 播放
        [self.player seekToTime:kCMTimeZero];// 每次都从零开始播放
        [self.player play];
        [self playStatus];
    }else{
        [self.player pause];
        [self stopStatus];
    }
}

#pragma mark - 监听播放完毕
-(void)avPlayerItemDidPlayToEndTime:(AVPlayer *)player{
    [self stopStatus];
}


#pragma mark - 播放状态和暂停状态
- (void)playStatus{
    [self.playBtn.imageView startAnimating]; // 更新喇叭图片
    self.totalTimeLabel.textColor = [UIColor orangeColor]; // 更新label的颜色
    [self.playBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal]; // 更新label的颜色
}
- (void)stopStatus{
    [self.playBtn.imageView stopAnimating];
    self.totalTimeLabel.textColor = [UIColor darkGrayColor];
    [self.playBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
}

@end
