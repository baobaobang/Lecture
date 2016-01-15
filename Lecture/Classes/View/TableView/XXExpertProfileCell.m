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

+ (instancetype)cell{
    return [[[NSBundle mainBundle] loadNibNamed:@"XXExpertProfileCell" owner:nil options:nil] lastObject];
}

//创建自定义可重用的cell对象
+ (instancetype)expertProfileCellInTableView:(UITableView *)tableView{
    static NSString *reuseId = @"expertProfileCell";
    XXExpertProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"XXExpertProfileCell" owner:nil options:nil] lastObject];
        // 设置cell选中时不变色
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

/**
 *  计算cell根据label内容自适应高度
 *
 *  @param str label内容
 */
-(void)cellAutoLayoutHeight:(NSString *)str{
    self.profileLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.profileLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.profileLabel.frame);
    self.profileLabel.text = str;
}

// 给cell的子控件赋值
- (void)setExpert:(XXExpert *)expert{
    _expert = expert;
    
    // 专家头像(圆形)
    UIImage *expertIcon = [UIImage circleImageWithName:expert.icon borderWidth:0 borderColor:[UIColor clearColor]];
    [self.iconBtn setBackgroundImage:expertIcon forState:UIControlStateNormal];
    
    // 名字
    self.nameLabel.text = expert.name;
    
    // 等级
    self.levelView.image = [UIImage imageNamed:expert.level];
    
    // 科室
    self.departmentLabel.text = expert.department;
    
    // 医院
    self.hospitalLabel.text = expert.hospital;
    
    // 简介
    self.profileLabel.text = expert.profile;

}

@end
