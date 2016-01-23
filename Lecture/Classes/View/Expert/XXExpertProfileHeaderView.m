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

@end

@implementation XXExpertProfileHeaderView

- (void)awakeFromNib{
    [super awakeFromNib];
    
    // 设置关注按钮的Normal状态和Selected状态
    [self.followBtn setTitle:@"关注" forState:UIControlStateNormal];
    [self.followBtn setBackgroundImage:[UIImage createImageWithColor:XXTintColor] forState:UIControlStateNormal];

    UIImage *followBtnImage = [[[UIImage imageNamed:@"add"] imageScaleToSize:CGSizeMake(10, 10)] imageRenderingModeAlwaysOriginal];
    [self.followBtn setImage:followBtnImage forState:UIControlStateNormal];
    [self.followBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    
    [self.followBtn setTitle:@"已关注" forState:UIControlStateSelected];
    [self.followBtn setBackgroundImage:[UIImage createImageWithColor:XXSelectedColor] forState:UIControlStateSelected];
}

- (IBAction)followBtnClick:(UIButton *)btn {
    
    btn.selected = !btn.selected;
}


@end
