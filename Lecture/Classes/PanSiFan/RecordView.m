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
@property (nonatomic, strong) AVAudioPlayer *player;
@property (nonatomic, strong) UIButton *playBtn;
@property (nonatomic, assign) NSInteger index;//
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UIButton *deleteBtn;
@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) BOOL isCurPlayView;
@end
@implementation RecordView

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
    rv.name = name;
    
    play.layer.cornerRadius = 3;
    play.backgroundColor = [UIColor colorWithRed:153/255 green:255/255 blue:52/255 alpha:1];
    
    [play setImage:[UIImage imageNamed:@"形状-3.3"] forState:0];
    play.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [play setImageEdgeInsets:UIEdgeInsetsMake(7.5, -45, 7.5, 5)];
    play.titleLabel.font = [UIFont systemFontOfSize:14];
    [play setTitle:name forState:0];
    [play setTitleEdgeInsets:UIEdgeInsetsMake(7.5,-50, 7.5, 0)];
    
    [play addTarget:rv action:@selector(playVoice) forControlEvents:UIControlEventTouchUpInside];
    [delete addTarget:rv action:@selector(deleteVoice:) forControlEvents:UIControlEventTouchUpInside];
    
    [delete setBackgroundImage:[UIImage imageNamed:@"Delete"] forState:0];
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
    
    
    _player = [[AudioTool shareAudioTool] playerWithURL:[NSURL URLWithString:self.path]];
    _player.delegate = self;
        
    
    
    if (_player.isPlaying) {
        [_player stop];
        [_playBtn setTitle:_name forState:0];
        [_timer invalidate];
        [_displayLink invalidate];
        [_playBtn setImage:[UIImage imageNamed:@"形状-3.3"] forState:0];
    }else{
        NSNotification *note = [[NSNotification alloc]initWithName:@"recordViewNote" object:nil userInfo:nil];
        [[NSNotificationCenter defaultCenter] postNotification:note];
       
        NSLog(@"%@",_player.url);
        if ([_player prepareToPlay]){
            [_player play];
            _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateTime)];
            [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
            _timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(animatePic) userInfo:nil repeats:YES];
        };
    }
}

//播放时的时间更新
- (void)updateTime{
    NSInteger intTime = (NSInteger)_player.currentTime;
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
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    [_player stop];
    [_playBtn setTitle:_name forState:0];
    _player = nil;
    [_timer invalidate];
    [_displayLink invalidate];
    [_playBtn setImage:[UIImage imageNamed:@"形状-3.3"] forState:0];
}

- (void)changePlayer{
    
    [_player stop];
    [_timer invalidate];
    [_displayLink invalidate];
    
    [_playBtn setTitle:_name forState:0];
    [_playBtn setImage:[UIImage imageNamed:@"形状-3.3"] forState:0];
    
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
