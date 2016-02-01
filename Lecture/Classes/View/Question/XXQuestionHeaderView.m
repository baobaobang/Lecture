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

@property (weak, nonatomic) IBOutlet UIButton *contractBtn;
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
    
    // 收起按钮用图片表示
//    [self.contractBtn setBackgroundImage:[UIImage imageNamed:@"icon-up"] forState:UIControlStateNormal];
//    [self.contractBtn setBackgroundImage:[UIImage imageNamed:@"icon-down"] forState:UIControlStateSelected];
//    self.contractBtn.tintColor = [UIColor whiteColor];// 取消选中状态下的小蓝点
    // 收起按钮用文字表示
    [self.contractBtn setTitle:@"展开提问" forState:UIControlStateNormal];
    [self.contractBtn setBackgroundImage:[UIImage createImageWithColor:XXColorTint] forState:UIControlStateNormal];
    
    [self.contractBtn setTitle:@"收起提问" forState:UIControlStateSelected];
    [self.contractBtn setBackgroundImage:[UIImage createImageWithColor:XXColorTint] forState:UIControlStateSelected];

    //TODO: 改收起按钮的文字颜色和背景色
    
}

// 点击提问按钮
- (IBAction)btnClick:(XXButton *)btn {
    
    if ([self.delegate respondsToSelector:@selector(questionHeaderView:didClickPostQuestionBtn:)]) {
        [self.delegate questionHeaderView:self didClickPostQuestionBtn:btn];
    }
}

/**
 *  收起和展开picView和专家简介部分
 */
- (IBAction)showAndHidePicView:(UIButton *)btn {
    
    if ([self.delegate respondsToSelector:@selector(questionHeaderView:didClickContractBtn:)]) {
        [self.delegate questionHeaderView:self didClickContractBtn:btn];
    }
    
    btn.selected = !btn.selected;
}

@end
