//
//  XXExpertProfileHeaderView.m
//  Lecture
//
//  Created by 陈旭 on 16/1/10.
//  Copyright © 2016年 陈旭. All rights reserved.
//

#import "XXExpertProfileHeaderView.h"

@interface XXExpertProfileHeaderView ()
@property (weak, nonatomic) IBOutlet UIButton *followBtn;

@end

@implementation XXExpertProfileHeaderView

- (void)awakeFromNib{
    [super awakeFromNib];
    
    // 设置关注按钮的Normal状态和Selected状态
    [self.followBtn setTitle:@"关注" forState:UIControlStateNormal];
    [self.followBtn setBackgroundImage:[UIImage createImageWithColor:HWTintColor] forState:UIControlStateNormal];
    
    [self.followBtn setTitle:@"已关注" forState:UIControlStateSelected];
    [self.followBtn setBackgroundImage:[UIImage createImageWithColor:HWSelectedColor] forState:UIControlStateSelected];
}

+ (instancetype)headerView{
    return [[[NSBundle mainBundle] loadNibNamed:@"XXExpertProfileHeaderView" owner:nil options:nil] lastObject];
}

- (IBAction)btnClick:(UIButton *)btn {
        btn.selected = !btn.selected;
}

@end
