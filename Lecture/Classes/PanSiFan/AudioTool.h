//
//  AudioTool.h
//  Lecture
//
//  Created by mortal on 16/2/1.
//  Copyright © 2016年 陈旭. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
@interface AudioTool : NSObject

@property (nonatomic, strong)  AVAudioPlayer*player;
@property (nonatomic, strong) AVAudioRecorder *recorder;

+ (instancetype)shareAudioTool;
- (AVAudioRecorder *)recorderWithURL:(NSURL *)url;
- (AVAudioPlayer *)playerWithURL:(NSURL *)url;

@end
