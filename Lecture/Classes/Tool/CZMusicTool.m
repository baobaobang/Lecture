//
//  CZMusicTool.m
//  A01_传智音乐
//
//  Created by apple on 15-3-2.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "CZMusicTool.h"

@interface CZMusicTool()


@end

@implementation CZMusicTool
singleton_implementation(CZMusicTool)

-(void)prepareToPlayWithMusic:(CZMusic *)music{
    //创建播放器
    
    NSURL *musicURL = [[NSBundle mainBundle] URLForResource:music.filename withExtension:nil];
    
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:musicURL error:nil];
    
    //准备
    [self.player prepareToPlay];
}


-(void)play{
    [self.player play];
}


-(void)pause{
    [self.player pause];
}
@end
