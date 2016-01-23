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

@property (weak, nonatomic) IBOutlet UIButton *upAndDownBtn;
@end

@implementation XXQuestionHeaderView

- (void)awakeFromNib{
    [super awakeFromNib];
    
    // 设置我要提问按钮文字和颜色
    [self.postQuestionBtn setTitle:@"我要提问" forState:UIControlStateSelected];
    
    UIImage *postQuestionBtnImage = [[[UIImage imageNamed:@"question"] imageScaleToSize:CGSizeMake(5, 20)] imageRenderingModeAlwaysOriginal];
    [self.postQuestionBtn setImage:postQuestionBtnImage forState:UIControlStateNormal];

    // 用纯色image作为背景可以实现按钮在disable状态下颜色变浅的效果
    [self.postQuestionBtn setBackgroundImage:[UIImage createImageWithColor:XXColorGreen] forState:UIControlStateNormal];
    
    [self.postQuestionBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    
    
    [self.postQuestionBtn setTitle:@"已提问" forState:UIControlStateDisabled];
//    [self.postQuestionBtn setBackgroundColor:XXColorGreen];
    
    
    [self.upAndDownBtn setBackgroundImage:[UIImage imageNamed:@"icon-up"] forState:UIControlStateNormal];
    [self.upAndDownBtn setBackgroundImage:[UIImage imageNamed:@"icon-down"] forState:UIControlStateSelected];
    self.upAndDownBtn.tintColor = [UIColor whiteColor];// 取消选中状态下的小蓝点
    
}


- (IBAction)btnClick:(XXButton *)btn {
    btn.enabled = NO;
}

/**
 *  收起和展开picView和专家简介部分
 */
- (IBAction)showAndHidePicView:(UIButton *)btn {
    
    if (!btn.selected) {// 点击普通状态就收起picView
        NSNotification *notiHide = [NSNotification notificationWithName:XXPlayerPicViewWillHide object:nil];
        [XXNotificationCenter postNotification:notiHide];
    }else{// 点击选中状态就展开picView
        NSNotification *notiShow = [NSNotification notificationWithName:XXPlayerPicViewWillShow object:self];
        [XXNotificationCenter postNotification:notiShow];
    }
    
    btn.selected = !btn.selected;
}

@end
