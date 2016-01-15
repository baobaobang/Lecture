//
//  XXQuestionHeaderView.m
//  Lecture
//
//  Created by 陈旭 on 16/1/10.
//  Copyright © 2016年 陈旭. All rights reserved.
//

#import "XXQuestionHeaderView.h"

@interface XXQuestionHeaderView ()
@property (weak, nonatomic) IBOutlet XXButton *postQuestionBtn;

@end

@implementation XXQuestionHeaderView

- (void)awakeFromNib{
    [super awakeFromNib];
    
    // 设置我要提问按钮文字和颜色
    [self.postQuestionBtn setTitle:@"我要提问" forState:UIControlStateSelected];
    [self.postQuestionBtn setBackgroundImage:[UIImage createImageWithColor:HWQuestionTintColor] forState:UIControlStateNormal];
    [self.postQuestionBtn setTitle:@"已提问" forState:UIControlStateDisabled];
}


- (IBAction)btnClick:(XXButton *)btn {
    btn.enabled = NO;
}

@end
