//
//  RecordButton.m
//  Upload
//
//  Created by mortal on 16/1/13.
//  Copyright © 2016年 禾医健康科技. All rights reserved.
//

#import "RecordButton.h"
#import "AudioTool.h"
@interface RecordButton()

@property (nonatomic, strong) UIView *recordingView;
@property (nonatomic, strong) UIButton *stateBtn;
@property (nonatomic, strong)  AVAudioRecorder *recorder;

@property (nonatomic, strong) CADisplayLink *displayLink;
@end
@implementation RecordButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
    }
    return self;
}

- (void)awakeFromNib{
//    self.backgroundColor = [UIColor redColor];
//    self.layer.cornerRadius = self.frame.size.height/2;
    [self addTarget:self action:@selector(record:) forControlEvents:UIControlEventTouchUpInside];
    //[self setTitle:@"开始录音" forState:0];
}
- (UIView *)recordingView{
    if (!_recordingView) {
        _recordingView = [[UIView alloc]initWithFrame:self.bounds];
        self.deleteBtn = [[UIButton alloc]initWithFrame:CGRectMake(2.5, 2.5, self.frame.size.height-5,  self.frame.size.height-5)];
        [self.deleteBtn setBackgroundImage:[UIImage imageNamed:@"delete-button"] forState:0];
        [self.deleteBtn addTarget:self action:@selector(stopRecord) forControlEvents:UIControlEventTouchUpInside];
        [_recordingView addSubview:self.deleteBtn];
        CGFloat H = self.frame.size.height;
        CGFloat W = self.frame.size.width;
        self.timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(W-50, 0, 55,H )];
        [self.timeLabel setTextColor:[UIColor whiteColor]];
        self.timeLabel.font = [UIFont systemFontOfSize:13];
        [_recordingView addSubview:self.timeLabel];
        
        UIImageView *wave = [[UIImageView alloc]initWithFrame:CGRectMake(H, 0, 100, H)];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(stopRecord)];
        [_recordingView addGestureRecognizer:tap];
        wave.image = [UIImage imageNamed:@"wave"];
        [_recordingView addSubview:wave];
        
    }
    return _recordingView;
}


- (void)record:(UIButton *)sender{
    [self addSubview:self.recordingView];
    
        NSString *document = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    
        if (!_recorder) {
            NSInteger num = self.voiceUrls.count+1;
            NSString *voiceName = [NSString stringWithFormat:@"lectureId%@title%@page%ldnumber%ld%@",self.pageModel.lectureId,self.pageModel.title,(long)self.pageModel.pageNo,num,@"voice.wav"];
            NSString *path = [document stringByAppendingPathComponent:voiceName];
            //_filePath = [NSURL URLWithString:path];
    
            [self.voiceUrls addObject:path];
    
            _recorder = [[AudioTool shareAudioTool] recorderWithURL:[NSURL URLWithString:path]];
            if (!_recorder) {
                [SVProgressHUD showErrorWithStatus:@"录音机初始化失败"];
            }
            _recorderState = RecorderStateStop;//停止状态
        }
        switch (_recorderState) {
            case RecorderStateRecording:
            {
    
//                [_recordBtn setBackgroundImage:nil forState:0];
//                [_recordBtn setTitle:@"开始录音" forState:0];
                [_displayLink invalidate];
                [self stopRecord];//保存
                _recorderState = RecorderStateStop;
    
            }
                break;
                case RecorderStateStop:
            {
                if ([_recorder prepareToRecord]) {
    
                    _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateTime)];
                    [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
                    [_recorder record];
                    _recorderState = RecorderStateRecording;//录音状态
                };
            }
                break;
            default:
                
                [_recorder pause];//暂停
                _recorderState = RecorderStatePause;
                [_displayLink invalidate];
             break;
        }
}

- (void)updateTime{
    NSInteger intTime = (NSInteger)_recorder.currentTime;
    NSInteger min = intTime/60;
    NSInteger sec = intTime%60;
    NSString *minStr = [NSString stringWithFormat:@"%ld",(long)min];
    NSString *secStr = [NSString stringWithFormat:@"%ld",(long)sec];
    if (min<10) {
        minStr = [NSString stringWithFormat:@"0%ld",(long)min];
    }
    if (sec<10) {
        secStr = [NSString stringWithFormat:@"0%ld",(long)sec];
    }
    self.timeLabel.text = [NSString stringWithFormat:@"%@:%@",minStr,secStr];
}

- (void)stopRecord {
    
    [self.recordingView removeFromSuperview];
    NSInteger intTime = (NSInteger)_recorder.currentTime;
    [_recorder stop];
    [_displayLink invalidate];
    _recorder = nil; //删除录音机,必须有这步  否则影响recorder创建逻辑
    _recorderState = RecorderStateStop;
    
    
    if (intTime<2) {
        [SVProgressHUD showInfoWithStatus:@"录音时间过短"];
        [_voiceUrls removeLastObject];
        return;
    }
    [self.delegate stopRecord:self];
}
@end
