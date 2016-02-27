//
//  XXExpertProfileCell.m
//  Lecture
//
//  Created by 陈旭 on 16/1/10.
//  Copyright © 2016年 陈旭. All rights reserved.
//

#import "XXExpertProfileCell.h"
#import "XXExpert.h"
#import "UIButton+WebCache.h"

@interface XXExpertProfileCell ()

@property (weak, nonatomic) IBOutlet UIView *grayContentView;
@property (weak, nonatomic) IBOutlet UIButton *iconBtn;// 专家头像
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;// 名字
@property (weak, nonatomic) IBOutlet UIImageView *levelView;// 等级
@property (weak, nonatomic) IBOutlet UILabel *departmentLabel;// 科室
@property (weak, nonatomic) IBOutlet UILabel *hospitalLabel;// 医院
@property (weak, nonatomic) IBOutlet UILabel *jobTitleLabel;// 职称
@property (weak, nonatomic) IBOutlet UILabel *profileLabel;// 简介

@end

@implementation XXExpertProfileCell

- (void)awakeFromNib{
    // 设置cell选中时不变色
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // 设置灰色容器为圆角
    self.grayContentView.layer.cornerRadius = 5;
    [self.grayContentView.layer masksToBounds];
    // 设置灰色容器的颜色
    self.grayContentView.backgroundColor = XXExpertProfileCellContentViewBackgroundColor;
}
//给cell的子控件赋值
- (void)setLecture:(XXXLectureModel *)lecture{
    _lecture = lecture;
    
    // 专家头像(圆形)
//    UIImage *expertIcon = [UIImage circleImageWithName: borderWidth:0 borderColor:[UIColor clearColor]];
    [self.iconBtn sd_setImageWithURL:[NSURL URLWithString:lecture.headPic] forState:0 placeholderImage:[UIImage imageNamed:@"placeholder_expert_Head"]];
    self.iconBtn.layer.cornerRadius = self.iconBtn.frame.size.width / 2;
    self.iconBtn.layer.masksToBounds = YES;
    
    // vip等级
    if (lecture == nil) {// 网络不好的情况
        self.levelView.image = nil;
    }else{
        self.levelView.image = [UIImage imageNamed:@"avatar_vip_os7"];
    }
    
    
    // 名字
    self.nameLabel.text = lecture.name;
    
    // 科室
    self.departmentLabel.text = lecture.department;
    
    // 医院
    self.hospitalLabel.text = lecture.hospital;
    
    // 职称
    self.jobTitleLabel.text = lecture.jobTitle;
    
    // 简介
    self.profileLabel.text = lecture.introduction;
}



@end
