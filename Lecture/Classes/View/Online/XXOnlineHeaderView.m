//
//  XXOnlineHeaderView.m
//  Lecture
//
//  Created by 陈旭 on 16/1/26.
//  Copyright © 2016年 陈旭. All rights reserved.
//

#import "XXOnlineHeaderView.h"

@interface XXOnlineHeaderView ()
@property (weak, nonatomic) IBOutlet UIButton *contractBtn;

@end

@implementation XXOnlineHeaderView

- (void)awakeFromNib{
    [super awakeFromNib];
    
    // 收起按钮用文字表示
    [self.contractBtn setTitle:@"展开提问" forState:UIControlStateNormal];
    [self.contractBtn setBackgroundImage:[UIImage createImageWithColor:XXColorTint] forState:UIControlStateNormal];
    
    [self.contractBtn setTitle:@"收起提问" forState:UIControlStateSelected];
    [self.contractBtn setBackgroundImage:[UIImage createImageWithColor:XXColorTint] forState:UIControlStateSelected];
    //TODO: 改收起按钮的文字颜色和背景色

}

/**
 *  收起和展开picView和专家简介部分
 */
- (IBAction)showAndHidePicView:(UIButton *)btn {
    
    if ([self.delegate respondsToSelector:@selector(onlineHeaderView:didClickContractBtn:)]) {
        [self.delegate onlineHeaderView:self didClickContractBtn:btn];
    }
    
    btn.selected = !btn.selected;
}

@end
