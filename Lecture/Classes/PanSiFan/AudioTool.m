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
            
            UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
            AudioSessionSetProperty (kAudioSessionProperty_OverrideAudioRoute,sizeof (audioRouteOverride),&audioRouteOverride);
            
            
            //外放 耳机切换时监听
            AudioSessionAddPropertyListener(kAudioSessionProperty_AudioRouteChange,audioRouteChangeListenerCallback, (__bridge void *)(self));
        }
    });
    return sharedInstance;
}

- (AVAudioRecorder *)recorderWithURL:(NSURL *)url{
    _recorder = nil;
    NSDictionary *recordSettings=[NSDictionary dictionaryWithObjectsAndKeys:
                                  [NSNumber numberWithInt:AVAudioQualityMin],
                                  AVEncoderAudioQualityKey,
                                  [NSNumber numberWithInt:16],
                                  AVEncoderBitRateKey,
                                  [NSNumber numberWithInt:2],
                                  AVNumberOfChannelsKey,
                                  [NSNumber numberWithFloat:SAMPLERATE],
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

- (AVPlayer *)streamPlayerWithURL:(NSString *)url{

    // 为了能够外放
    UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
    AudioSessionSetProperty (kAudioSessionProperty_OverrideAudioRoute,sizeof (audioRouteOverride),&audioRouteOverride);
    // 暂停前面一个
    [_streamPlayer pause];
    // 同时支持本地和网络播放
    NSURL *URL; 
    if ( [url hasPrefix:@"http"]) {
        URL = [NSURL URLWithString:url];
    }else{
        URL = [NSURL fileURLWithPath:url];
    }
    // 一次只有一个player
    _streamPlayer = [[AVPlayer alloc]initWithURL:URL];
    return _streamPlayer;
}

- (AVPlayer *)noSinglePlayerWithURL:(NSString *)url{
//    UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
//    AudioSessionSetProperty (kAudioSessionProperty_OverrideAudioRoute,sizeof (audioRouteOverride),&audioRouteOverride);
    // 暂停前面一个
    [_streamPlayer pause];
    // 同时支持本地和网络播放
    NSURL *URL;
    if ( [url hasPrefix:@"http"]) {
        URL = [NSURL URLWithString:url];
    }else{
        URL = [NSURL fileURLWithPath:url];
    }
    
    return [[AVPlayer alloc]initWithURL:URL];
}


//触发的监听事件
void audioRouteChangeListenerCallback (void *inUserData, AudioSessionPropertyID inPropertyID, UInt32 inPropertyValueSize,const void *inPropertyValue ) {
    // ensure that this callback was invoked for a route change
    if (inPropertyID != kAudioSessionProperty_AudioRouteChange) return;
    
    
    {
        // Determines the reason for the route change, to ensure that it is not
        //      because of a category change.
        CFDictionaryRef routeChangeDictionary = (CFDictionaryRef)inPropertyValue;
        
        CFNumberRef routeChangeReasonRef = (CFNumberRef)CFDictionaryGetValue (routeChangeDictionary, CFSTR (kAudioSession_AudioRouteChangeKey_Reason) );
        SInt32 routeChangeReason;
        CFNumberGetValue (routeChangeReasonRef, kCFNumberSInt32Type, &routeChangeReason);
        
        if (routeChangeReason == kAudioSessionRouteChangeReason_OldDeviceUnavailable) {
            
            //Handle Headset Unplugged
            //NSLog(@"拔出耳机>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
            UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
            AudioSessionSetProperty (kAudioSessionProperty_OverrideAudioRoute,sizeof (audioRouteOverride),&audioRouteOverride);
            //DLog(@"没有耳机！");
            //HeadestUnplugged note
            NSNotification *note = [[NSNotification alloc]initWithName:NOTIFICATION_HEADESTUNPLUGGED object:nil userInfo:nil];
            [[NSNotificationCenter defaultCenter] postNotification:note];
        } else if (routeChangeReason == kAudioSessionRouteChangeReason_NewDeviceAvailable) {
            //Handle Headset plugged in
            //DLog(@"有耳机！");
            //NSLog(@"插入耳机>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
            NSNotification *note = [[NSNotification alloc]initWithName:NOTIFICATION_HEADESTPLUGGED object:nil userInfo:nil];
            [[NSNotificationCenter defaultCenter] postNotification:note];
            
        }
        
    }
}
@end
