//
//  XXStatusToolbar.h
//  黑马微博2期
//
//  Created by apple on 14-10-16.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXQuestion.h"
typedef enum{
    XXQuestionToolbarButtonTypeRetweet,
    XXQuestionToolbarButtonTypeReply,
    XXQuestionToolbarButtonTypeUnlike
}XXQuestionToolbarButtonType;

@class XXQuestionToolbar;
@protocol XXQuestionToolbarDelegate <NSObject>
@optional
- (void)questionToolbar:(XXQuestionToolbar *)toolbar didClickBtnType:(XXQuestionToolbarButtonType)type;

@end

@interface XXQuestionToolbar : UIView

@property (nonatomic, strong) XXQuestion *question;

@property (nonatomic, weak) UIButton *shareBtn;
@property (nonatomic, weak) UIButton *replyBtn;
@property (nonatomic, weak) UIButton *attitudeBtn;
+ (instancetype)toolbar;

@property (nonatomic, weak) id<XXQuestionToolbarDelegate> delegate;
@end
