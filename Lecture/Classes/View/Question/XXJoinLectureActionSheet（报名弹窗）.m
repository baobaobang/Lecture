//
//  XXJoinLectureActionSheet.m
//  Lecture
//
//  Created by 陈旭 on 16/1/23.
//  Copyright © 2016年 陈旭. All rights reserved.
//

#import "XXJoinLectureActionSheet.h"
#import "XXLecture.h"




@interface XXJoinLectureActionSheet ()
@property (nonatomic, weak) UIView *actionSheet;
@property (nonatomic, weak) UILabel *nameLabel;
@property (nonatomic, weak) UILabel *timeLabel;
@property (nonatomic, weak) UILabel *expertLabel;
@property (nonatomic, weak) UILabel *pointsLabel;
@property (nonatomic, weak) XXButton *doneBtn;
@property (nonatomic, weak) UIButton *cancelBtn;

@end

@implementation XXJoinLectureActionSheet

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        // 设置自己的属性(自己为灰底)
        self.frame = CGRectMake(0, 0, XXScreenWidth, XXScreenHeight);
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        
        // 点击背景退出，可以不实现这个功能，强迫用户报名
//        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancel)];
//        [self addGestureRecognizer:tapGesture];

        // actionSheet
        UIView *actionSheet = [[UIView alloc] init];
        actionSheet.backgroundColor = XXColorGreen;
        [self addSubview:actionSheet];
        self.actionSheet = actionSheet;
        
        // nameLabel
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.textColor = XXColorText;
        nameLabel.font = [UIFont systemFontOfSize:kXXJoinLectureActionSheetLabelFont];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        [self.actionSheet addSubview:nameLabel];
        self.nameLabel = nameLabel;
        
        // timeLabel
        UILabel *timeLabel = [[UILabel alloc] init];
        timeLabel.textColor = XXColorText;
        timeLabel.font = [UIFont systemFontOfSize:kXXJoinLectureActionSheetLabelFont];
        timeLabel.textAlignment = NSTextAlignmentCenter;
        [self.actionSheet addSubview:timeLabel];
        self.timeLabel = timeLabel;
        
        // expertLabel
        UILabel *expertLabel = [[UILabel alloc] init];
        expertLabel.textColor = XXColorText;
        expertLabel.font = [UIFont systemFontOfSize:kXXJoinLectureActionSheetLabelFont];
        expertLabel.textAlignment = NSTextAlignmentCenter;
        [self.actionSheet addSubview:expertLabel];
        self.expertLabel = expertLabel;
        
        // pointsLabel
        UILabel *pointsLabel = [[UILabel alloc] init];
        pointsLabel.textColor = [UIColor redColor];
        pointsLabel.font = [UIFont systemFontOfSize:kXXJoinLectureActionSheetLabelFont];
        pointsLabel.textAlignment = NSTextAlignmentCenter;
        [self.actionSheet addSubview:pointsLabel];
        self.pointsLabel = pointsLabel;
        
        // doneBtn
        XXButton *doneBtn = [[XXButton alloc] init];
        [doneBtn setTitle:@"确认报名" forState:UIControlStateNormal];
        [doneBtn setTitleColor:XXColorText forState:UIControlStateNormal];
        doneBtn.titleLabel.font = [UIFont systemFontOfSize:kXXJoinLectureActionSheetDoneBtnFont];
        [doneBtn setBackgroundColor:XXColorTint];
        [doneBtn addTarget:self action:@selector(done:) forControlEvents:UIControlEventTouchUpInside];
        [self.actionSheet addSubview:doneBtn];
        self.doneBtn = doneBtn;
        
        // cancelBtn
        UIButton *cancelBtn = [[UIButton alloc] init];
        [cancelBtn setBackgroundImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];//TODO:需要图片
        [cancelBtn addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
        [self.actionSheet addSubview:cancelBtn];
        self.cancelBtn = cancelBtn;
        
    }
    return self;
}

- (void)setLecture:(XXLecture *)lecture{
    _lecture = lecture;
    
    // nameLabel
    _nameLabel.text = [NSString stringWithFormat:@"主题：%@", lecture.name];
    
    // timeLabel
    _timeLabel.text = @"时间：2016-2-11 20:00-21:00";
    //TODO: 报名时间计算
    
    // expertLabel
    NSMutableString *expertStr = [NSMutableString string];
    NSUInteger count = lecture.experts.count;
    for (NSUInteger i = 0; i < count; i++) {
        XXExpert *expert = lecture.experts[i];
        if (i != count - 1) { // 不是最后一位专家
            [expertStr appendFormat:@"%@，", expert.name];
        }else{
            [expertStr appendString:expert.name];
        }
    }
    _expertLabel.text =
    [NSString stringWithFormat:@"专家：%@", expertStr];
    
    // pointsLabel
    _pointsLabel.text = [NSString stringWithFormat:@"报名需要消费%zd积分!", lecture.points];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    // actionSheet
    _actionSheet.frame = CGRectMake(0, self.height, self.width, kXXJoinLectureActionSheetHeight);

    CGFloat width = self.width;
    CGFloat height = 25;
    CGFloat margin = 3;
    
    // nameLabel
    _nameLabel.frame = CGRectMake(0, 25, width, height);
    
    // timeLabel
    CGFloat timeY = CGRectGetMaxY(_nameLabel.frame) + margin;
    _timeLabel.frame = CGRectMake(0, timeY, width, height);
    
    // expertLabel
    CGFloat expertY = CGRectGetMaxY(_timeLabel.frame) + margin;
    _expertLabel.frame = CGRectMake(0, expertY, width, height);
    
    // pointsLabel
    CGFloat pointsY = CGRectGetMaxY(_expertLabel.frame) + margin;
    _pointsLabel.frame = CGRectMake(0, pointsY, width, height);
    
    // doneBtn
    CGFloat doneX = 20;
    CGFloat doneY = CGRectGetMaxY(_pointsLabel.frame) + margin;
    CGFloat doneW = width - 2 * doneX;
    CGFloat doneH = 44;
    _doneBtn.frame = CGRectMake(doneX, doneY, doneW, doneH);
    
    // cancelBtn
    CGFloat cancelWH = 20;
    CGFloat cancelX = width - cancelWH;
    CGFloat cancelY = 0;
    _cancelBtn.frame = CGRectMake(cancelX, cancelY, cancelWH, cancelWH);
}

- (void)done:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(joinLectureActionSheet:didClickDoneButton:)]) {
        [self.delegate joinLectureActionSheet:self didClickDoneButton:btn];
    }
    [self cancel];
}

- (void)cancel{
    [UIView animateWithDuration:kXXJoinLectureActionSheetDuration animations:^{
  
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        self.actionSheet.y += self.actionSheet.height;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

-(void)showInView:(UIView *)view{
    [view addSubview:self];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:kXXJoinLectureActionSheetDuration animations:^{
            
            self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
            self.actionSheet.y -= self.actionSheet.height;
        } completion:^(BOOL finished) {
        }];
    });
}

@end
