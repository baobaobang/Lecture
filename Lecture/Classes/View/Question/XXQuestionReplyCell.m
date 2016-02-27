//
//  XXQuestionReplyCell.m
//  Lecture
//
//  Created by 陈旭 on 16/1/28.
//  Copyright © 2016年 陈旭. All rights reserved.
//

#import "XXQuestionReplyCell.h"
#import <AVFoundation/AVFoundation.h>


@interface XXQuestionReplyCell ()<AVAudioPlayerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet XXButton *playBtn;
@property (nonatomic, strong) AVAudioPlayer *player;
@property (nonatomic, assign, getter=isPlaying) BOOL playing;
@property (strong,nonatomic) CADisplayLink *link;
@end

@implementation XXQuestionReplyCell
#pragma mark - 懒加载
-(CADisplayLink *)link{
    if (!_link) {
        _link = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateLabel)];
        _link.paused = YES;
    }
    
    return _link;
}

#pragma mark - 生命周期

-(void)dealloc{
    //移除定时器
    [self.link removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.userNameLabel.font = XXQuestionCellReplyFont;
    self.userNameLabel.numberOfLines = 0;
    
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
    
    // 开启定时器
    [self.link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
//    self.link.paused = YES;
}

- (void)setReply:(XXReply *)reply{
    _reply = reply;
    
    self.userNameLabel.text = reply.nickName;
    [self setupPlayBtn:reply];
}

- (void)setupPlayBtn:(XXReply *)reply{
    // 初始化一个 "音频播放器"player，一首音乐对应一个player
    NSURL *musicURL = [[NSBundle mainBundle] URLForResource:reply.mp3Str withExtension:nil];//TODO: 回复中的网络音频播放
    AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:musicURL error:nil];
    
    // 准备
    [player prepareToPlay];
    
    // 设置player的代理
    player.delegate = self;
    
    // 重置当前播放时间为0
    player.currentTime = 0;
    
    // 设置默认显示总时长
    double duration = player.duration;
    [self.playBtn setTitle:[NSString getHourMinuteSecondWithSecond:duration] forState:UIControlStateNormal];
    //
    self.player = player;
}

- (IBAction)clickPlayBtn:(XXButton *)btn {
    self.playing = !self.playing;
    if (self.playing) { // 播放
        [self.player play];
        
        [self.playBtn.imageView startAnimating]; // 更新喇叭图片
        self.link.paused = NO; // 更新label的时间
        [self.playBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal]; // 更新label的颜色
    }else{
        [self.player pause];
        [self.playBtn.imageView stopAnimating];
        self.link.paused = YES;
        [self.playBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }
}

-(void)updateLabel{
    
    [self.playBtn setTitle:[NSString getHourMinuteSecondWithSecond:self.player.currentTime] forState:UIControlStateNormal];
}


@end
