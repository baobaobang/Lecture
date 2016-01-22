//
//  XXExpertProfileHeaderView.m
//  Lecture
//
//  Created by 陈旭 on 16/1/10.
//  Copyright © 2016年 陈旭. All rights reserved.
//

#import "XXExpertProfileHeaderView.h"
#import "XXExpert.h"

@interface XXExpertProfileHeaderView ()
@property (weak, nonatomic) IBOutlet UIButton *followBtn;
@property (weak, nonatomic) IBOutlet UIButton *upAndDownBtn;

@end

@implementation XXExpertProfileHeaderView

- (void)awakeFromNib{
    [super awakeFromNib];
    
    // 设置关注按钮的Normal状态和Selected状态
    [self.followBtn setTitle:@"关注" forState:UIControlStateNormal];
    [self.followBtn setBackgroundImage:[UIImage createImageWithColor:HWTintColor] forState:UIControlStateNormal];

    UIImage *followBtnImage = [[[UIImage imageNamed:@"add"] imageScaleToSize:CGSizeMake(10, 10)] imageRenderingModeAlwaysOriginal];
    [self.followBtn setImage:followBtnImage forState:UIControlStateNormal];
    [self.followBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    
    [self.followBtn setTitle:@"已关注" forState:UIControlStateSelected];
    [self.followBtn setBackgroundImage:[UIImage createImageWithColor:HWSelectedColor] forState:UIControlStateSelected];
    
    
    [self.upAndDownBtn setBackgroundImage:[UIImage imageNamed:@"icon-up"] forState:UIControlStateNormal];
    [self.upAndDownBtn setBackgroundImage:[UIImage imageNamed:@"icon-down"] forState:UIControlStateSelected];
    self.upAndDownBtn.tintColor = [UIColor whiteColor];// 取消选中状态下的小蓝点
    
}

- (IBAction)followBtnClick:(UIButton *)btn {
    
    btn.selected = !btn.selected;
}

/**
 *  收起和展开picView
 */
- (IBAction)showAndHidePicView:(UIButton *)btn {
    
    if (!btn.selected) {// 点击普通状态就收起picView
        NSNotification *notiHide = [NSNotification notificationWithName:XXPlayerPicViewWillHide object:nil];
        [HWNotificationCenter postNotification:notiHide];
    }else{// 点击选中状态就展开picView
        NSNotification *notiShow = [NSNotification notificationWithName:XXPlayerPicViewWillShow object:self];
        [HWNotificationCenter postNotification:notiShow];
    }
    
    btn.selected = !btn.selected;
}

@end
