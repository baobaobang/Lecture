//
//  XXExpertProfileCell.m
//  Lecture
//
//  Created by 陈旭 on 16/1/10.
//  Copyright © 2016年 陈旭. All rights reserved.
//

#import "XXExpertProfileCell.h"
#import "XXExpert.h"

@interface XXExpertProfileCell ()

@property (weak, nonatomic) IBOutlet UIButton *iconBtn;// 专家头像
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;// 名字
@property (weak, nonatomic) IBOutlet UIImageView *levelView;// 等级
@property (weak, nonatomic) IBOutlet UILabel *departmentLabel;// 科室
@property (weak, nonatomic) IBOutlet UILabel *hospitalLabel;// 医院
@property (weak, nonatomic) IBOutlet UILabel *profileLabel;// 简介

@end

@implementation XXExpertProfileCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        // 设置cell选中时不变色
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

// 给cell的子控件赋值
//- (void)setExpert:(XXExpert *)expert{
//    _expert = expert;
//    
//    // 专家头像(圆形)
//    UIImage *expertIcon = [UIImage circleImageWithName:expert.icon borderWidth:0 borderColor:[UIColor clearColor]];
//    [self.iconBtn setBackgroundImage:expertIcon forState:UIControlStateNormal];
//    
//    // 名字
//    self.nameLabel.text = expert.name;
//    
//    // 等级
//    self.levelView.image = [UIImage imageNamed:expert.level];
//    
//    // 科室
//    self.departmentLabel.text = expert.department;
//    
//    // 医院
//    self.hospitalLabel.text = expert.hospital;
//    
//    // 简介
//    self.profileLabel.text = expert.profile;
//
//}

@end
