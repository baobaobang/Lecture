//
//  AudioTool.m
//  Lecture
//
//  Created by mortal on 16/2/1.
//  Copyright © 2016年 陈旭. All rights reserved.
//

#import "AudioTool.h"

@implementation AudioTool

+ (instancetype)shareAudioTool{
    static dispatch_once_t onceToken;
    static AudioTool *sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        if (!sharedInstance) {
            sharedInstance = [[self alloc]init];
            [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
        }
    });
    return sharedInstance;
}

- (AVAudioRecorder *)recorderWithURL:(NSURL *)url{
    NSDictionary *recordSettings=[NSDictionary dictionaryWithObjectsAndKeys:
                                  [NSNumber numberWithInt:AVAudioQualityMin],
                                  AVEncoderAudioQualityKey,
                                  [NSNumber numberWithInt:16],
                                  AVEncoderBitRateKey,
                                  [NSNumber numberWithInt:2],
                                  AVNumberOfChannelsKey,
                                  [NSNumber numberWithFloat:44100.0],
                                  AVSampleRateKey,
                                  [NSNumber numberWithInt: kAudioFormatLinearPCM],AVFormatIDKey,nil];
    self.recorder = [[AVAudioRecorder alloc]initWithURL:url settings:recordSettings error:nil];
    return self.recorder;
}

- (AVAudioPlayer *)playerWithURL:(NSURL *)url{
    
    UInt32 sessionCategory = kAudioSessionCategory_MediaPlayback;
    AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, sizeof(sessionCategory), &sessionCategory);
    UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
    AudioSessionSetProperty (kAudioSessionProperty_OverrideAudioRoute,sizeof (audioRouteOverride),&audioRouteOverride);
    
    self.player = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
    return self.player;
}
@end
