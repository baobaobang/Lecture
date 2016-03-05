//
//  XXExpertReplyView.m
//  Lecture
//
//  Created by 陈旭 on 16/3/4.
//  Copyright © 2016年 陈旭. All rights reserved.
//

#import "XXExpertReplyView.h"

@interface XXExpertReplyView ()
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UILabel *headerLabel;
@property (weak, nonatomic) IBOutlet UIButton *middleBtn;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UILabel *bottomLabel;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (nonatomic, strong) CADisplayLink *link;
@end

@implementation XXExpertReplyView

- (void)dealloc{
    [_link removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (CADisplayLink *)link{
    if (!_link) {
        _link = [CADisplayLink displayLinkWithTarget:self selector:@selector(refreshHeaderLabel)];
    }
    return _link;
}

- (void)awakeFromNib{
    UIColor *labelColor = XXColor(9, 79, 192);
    self.cancelButton.titleLabel.textColor = labelColor;
    self.sendButton.titleLabel.textColor = labelColor;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickTopView:)];
    [self.topView addGestureRecognizer:tap];
    
    [self.link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    switch (_status) {
        case XXExpertReplyButtonStatusInitial:
            [_middleBtn setBackgroundImage:[UIImage imageNamed:@"expertReplyInitial"] forState:UIControlStateNormal];
            _bottomView.hidden = YES;
            _bottomLabel.hidden = NO;
            _bottomLabel.text = @"语音回复";
            break;
        case XXExpertReplyButtonStatusRecording:
            [_middleBtn setBackgroundImage:[UIImage imageNamed:@"expertReplyRecording"] forState:UIControlStateNormal];
            _bottomView.hidden = YES;
            _bottomLabel.hidden = NO;
            _bottomLabel.text = @"正在录音";
            break;
        case XXExpertReplyButtonStatusStop:
            [_middleBtn setBackgroundImage:[UIImage imageNamed:@"expertReplyStop"] forState:UIControlStateNormal];
            _bottomView.hidden = NO;
            _bottomLabel.hidden = YES;
            _link = nil;
            break;
        case XXExpertReplyButtonStatusPlaying:
            [_middleBtn setBackgroundImage:[UIImage imageNamed:@"expertReplyRecording"] forState:UIControlStateNormal];
            _bottomView.hidden = NO;
            _bottomLabel.hidden = YES;
            break;
        default:
        break;
    }
}
- (IBAction)cancel:(id)sender {
    if ([self.delegate respondsToSelector:@selector(expertReplyView:didClickCancleButton:)]) {
        [self.delegate expertReplyView:self didClickCancleButton:sender];
    }
}
- (IBAction)send:(id)sender {
    if ([self.delegate respondsToSelector:@selector(expertReplyView:didClickSendButton:)]) {
        [self.delegate expertReplyView:self didClickSendButton:sender];
    }
}
- (IBAction)middleBtnClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(expertReplyView:didClickMiddleButton:)]) {
        [self.delegate expertReplyView:self didClickMiddleButton:sender];
    }
}

- (void)clickTopView:(UIGestureRecognizer *)gesture{
    if ([self.delegate respondsToSelector:@selector(expertReplyView:didClickTopView:)]) {
        [self.delegate expertReplyView:self didClickTopView:gesture.view];
    }
}

- (void)setStatus:(XXExpertReplyButtonStatus)status{
    _status = status;

    [self setNeedsLayout];
}

// 实时更新HeaderLabel
- (void)refreshHeaderLabel{
    switch (self.status) {
        case XXExpertReplyButtonStatusInitial:// 开始录音
        {
            _headerLabel.text = @"点击录音";
        }
            break;
        case XXExpertReplyButtonStatusRecording:// 结束录音
        {
            _headerLabel.text = [NSString getMinuteSecondWithSecond:self.recorder.currentTime];
            break;
        }
        case XXExpertReplyButtonStatusStop:// 开始播放
        {
            _headerLabel.text = [NSString getMinuteSecondWithSecond:self.player.duration];
            break;
        }
        case XXExpertReplyButtonStatusPlaying:// 结束播放
        {
            _headerLabel.text = [NSString getMinuteSecondWithSecond:self.player.currentTime];
            break;
        }
        default:
            break;
    }
}
@end
