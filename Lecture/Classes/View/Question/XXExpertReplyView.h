 //
//  XXExpertReplyView.h
//  Lecture
//
//  Created by 陈旭 on 16/3/4.
//  Copyright © 2016年 陈旭. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum{
    XXExpertReplyButtonStatusInitial,
    XXExpertReplyButtonStatusPrepare,
    XXExpertReplyButtonStatusRecording,
    XXExpertReplyButtonStatusStop,
    XXExpertReplyButtonStatusPlaying
}XXExpertReplyButtonStatus;

@class XXExpertReplyView;

@protocol XXExpertReplyViewDelegate <NSObject>

@optional
- (void)expertReplyView:(XXExpertReplyView *)expertReplyView didClickMiddleButton:(UIButton *)btn;
- (void)expertReplyView:(XXExpertReplyView *)expertReplyView didClickCancleButton:(UIButton *)btn;
- (void)expertReplyView:(XXExpertReplyView *)expertReplyView didClickSendButton:(UIButton *)btn;
- (void)expertReplyView:(XXExpertReplyView *)expertReplyView didClickTopView:(UIView *)view;

@end
@interface XXExpertReplyView : UIView

@property (nonatomic, assign) XXExpertReplyButtonStatus status;
@property (nonatomic, weak) id<XXExpertReplyViewDelegate> delegate;
@end
