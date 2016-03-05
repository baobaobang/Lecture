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

@end

@implementation XXExpertReplyView

- (void)awakeFromNib{
    UIColor *labelColor = XXColor(9, 79, 192);
    self.cancelButton.titleLabel.textColor = labelColor;
    self.sendButton.titleLabel.textColor = labelColor;
    self.bottomLabel.textColor = labelColor;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickTopView:)];
    [self.topView addGestureRecognizer:tap];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    switch (_status) {
        case XXExpertReplyButtonStatusInitial:
            _headerLabel.text = @"点击录音";
            [_middleBtn setBackgroundImage:[UIImage imageNamed:@"expertReplyInitial"] forState:UIControlStateNormal];
            _bottomView.hidden = YES;
            _bottomLabel.hidden = NO;
            break;
        case XXExpertReplyButtonStatusPrepare:
            _headerLabel.text = @"准备中...";
            [_middleBtn setBackgroundImage:[UIImage imageNamed:@"expertReplyInitial"] forState:UIControlStateNormal];
            _bottomView.hidden = YES;
            _bottomLabel.hidden = NO;
            break;
        case XXExpertReplyButtonStatusRecording:
            _headerLabel.text = @"";
            [_middleBtn setBackgroundImage:[UIImage imageNamed:@"expertReplyRecording"] forState:UIControlStateNormal];
            _bottomView.hidden = YES;
            _bottomLabel.hidden = NO;
            break;
        case XXExpertReplyButtonStatusStop:
            _headerLabel.text = @"";
            [_middleBtn setBackgroundImage:[UIImage imageNamed:@"expertReplyStop"] forState:UIControlStateNormal];
            _bottomView.hidden = NO;
            _bottomLabel.hidden = YES;
            break;
        case XXExpertReplyButtonStatusPlaying:
            _headerLabel.text = @"";
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
@end
