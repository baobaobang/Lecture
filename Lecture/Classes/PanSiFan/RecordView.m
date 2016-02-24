//
//  RecordView.m
//  Upload
//
//  Created by mortal on 16/1/12.
//  Copyright © 2016年 禾医健康科技. All rights reserved.
//

#import "RecordView.h"
#import "AudioTool.h"
@interface RecordView()<UIAlertViewDelegate,AVAudioPlayerDelegate>

@property (nonatomic, copy) NSString *path;
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) UIButton *playBtn;
@property (nonatomic, assign) NSInteger index;//
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UIButton *deleteBtn;
@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) BOOL isCurPlayView;
@end
@implementation RecordView
{
    BOOL playing;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        playing = NO;
    }
    return self;
}
+ (RecordView *)viewWithUrl:(NSString *)url index:(NSInteger)index name:(NSString *)name{
    
    RecordView *rv = [[RecordView alloc]initWithFrame:CGRectMake(0,(index-1)*40, 200, 40)];
    rv.path = url;
    
    [[NSNotificationCenter defaultCenter]addObserver:rv selector:@selector(changePlayer) name:@"recordViewNote" object:nil];
    
    
    UIButton *play = [[UIButton alloc]initWithFrame:CGRectMake(0, 5, 120, 30)];
    UIButton *delete = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(play.frame)+10, 5, 34, 30)];
    rv.tag = 1000+index;
    [rv addSubview:play];
    [rv addSubview:delete];
    rv.playBtn = play;
    rv.name = name.length == 0 ? @"00:00":name;
    
    play.layer.cornerRadius = 3;
    play.backgroundColor = [UIColor colorWithRed:153/255 green:255/255 blue:52/255 alpha:1];
    
    [play setImage:[UIImage imageNamed:@"形状-3.3"] forState:0];
    play.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [play setImageEdgeInsets:UIEdgeInsetsMake(7.5, -45, 7.5, 5)];
    play.titleLabel.font = [UIFont systemFontOfSize:14];
    [play setTitle:rv.name forState:0];
    [play setTitleEdgeInsets:UIEdgeInsetsMake(7.5,-50, 7.5, 0)];
    
    [play addTarget:rv action:@selector(playVoice) forControlEvents:UIControlEventTouchUpInside];
    [delete addTarget:rv action:@selector(deleteVoice:) forControlEvents:UIControlEventTouchUpInside];
    
    [delete setBackgroundImage:[UIImage imageNamed:@"Delete"] forState:0];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:rv selector:@selector(endPlay) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    
    
    return rv;
}

- (void)deleteVoice:(UIButton *)sender{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"确认删除?" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    [alert show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [self removeFromSuperview];
        [self.delegate deleteAtIndex:self.tag];
    }
}

//播放音频
- (void)playVoice{
    
    if (playing) {
        [_player pause];
        playing = NO;
        [_playBtn setTitle:_name forState:0];
        [_timer invalidate];
        [_displayLink invalidate];
        [_playBtn setImage:[UIImage imageNamed:@"形状-3.3"] forState:0];
    }else{
       
        _player = [[AudioTool shareAudioTool] streamPlayerWithURL:self.path];
        NSNotification *note = [[NSNotification alloc]initWithName:@"recordViewNote" object:nil userInfo:nil];
        [[NSNotificationCenter defaultCenter] postNotification:note];
       
        [_player play];
        playing = YES;
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateTime)];
        [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(animatePic) userInfo:nil repeats:YES];
        
    }
}

//播放时的时间更新
- (void)updateTime{
    NSInteger intTime = (NSInteger)CMTimeGetSeconds(_player.currentTime);
    NSInteger min = intTime/60;
    NSInteger sec = intTime%60;
    NSString *minStr = [NSString stringWithFormat:@"%ld",min];
    NSString *secStr = [NSString stringWithFormat:@"%ld",sec];
    if (min<10) {
        minStr = [NSString stringWithFormat:@"0%ld",min];
    }
    if (sec<10) {
        secStr = [NSString stringWithFormat:@"0%ld",sec];
    }
    [self.playBtn setTitle:[NSString stringWithFormat:@"%@:%@",minStr,secStr] forState:0];
}

//播放时的喇叭动画
- (void)animatePic{
    NSInteger num = _index%3;
    NSString *name = [NSString stringWithFormat:@"形状-3.%ld",num+1];
    _index ++;
    [_playBtn setImage:[UIImage imageNamed:name]forState:0];
}

//完成播放回调
- (void)endPlay{
    [_player pause];
    [_playBtn setTitle:_name forState:0];
//    _player = nil;
    [_timer invalidate];
    [_displayLink invalidate];
    [_playBtn setImage:[UIImage imageNamed:@"形状-3.3"] forState:0];
}

//- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
//    
//}

- (void)changePlayer{
    
    [_player pause];
    [_timer invalidate];
    [_displayLink invalidate];
    
    [_playBtn setTitle:_name forState:0];
    [_playBtn setImage:[UIImage imageNamed:@"形状-3.3"] forState:0];
    
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
