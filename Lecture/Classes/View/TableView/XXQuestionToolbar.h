//
//  XXStatusToolbar.h
//  黑马微博2期
//
//  Created by apple on 14-10-16.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXQuestion.h"

@interface XXQuestionToolbar : UIView

@property (nonatomic, strong) XXQuestion *question;

@property (nonatomic, weak) UIButton *shareBtn;
@property (nonatomic, weak) UIButton *commentBtn;
@property (nonatomic, weak) UIButton *attitudeBtn;
+ (instancetype)toolbar;
@end
