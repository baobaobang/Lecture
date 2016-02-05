//
//  XXContractButton.m
//  Lecture
//
//  Created by 陈旭 on 16/2/5.
//  Copyright © 2016年 陈旭. All rights reserved.
//

#import "XXContractButton.h"

#define XXContractButtonMargin 3

@implementation XXContractButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.tintColor = [UIColor whiteColor];// 取消选中状态下的小蓝点
        
        [self setTitle:@"展开提问" forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:@"before_spread_problem"] forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage createImageWithColor:XXColorTint] forState:UIControlStateNormal];
        
        [self setTitle:@"收起提问" forState:UIControlStateSelected];
        [self setBackgroundImage:[UIImage createImageWithColor:XXColorTint] forState:UIControlStateSelected];
        [self setImage:[UIImage imageNamed:@"before_contract_problem"] forState:UIControlStateSelected];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        self.tintColor = [UIColor whiteColor];// 取消选中状态下的小蓝点
        
        [self setTitle:@"展开提问" forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:@"before_spread_problem"] forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage createImageWithColor:XXColorTint] forState:UIControlStateNormal];
        
        [self setTitle:@"收起提问" forState:UIControlStateSelected];
        [self setBackgroundImage:[UIImage createImageWithColor:XXColorTint] forState:UIControlStateSelected];
        [self setImage:[UIImage imageNamed:@"before_contract_problem"] forState:UIControlStateSelected];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    // 如果仅仅是调整按钮内部titleLabel和imageView的位置，那么在layoutSubviews中单独设置位置即可
    // 防止这个方法调用两次
    if (self.titleLabel.x <= self.imageView.x)return;
    
    // 1.计算titleLabel的frame
    self.titleLabel.x = self.imageView.x - XXContractButtonMargin;
    
    // 2.计算imageView的frame
    self.imageView.x = CGRectGetMaxX(self.titleLabel.frame) + XXContractButtonMargin;
}

@end
