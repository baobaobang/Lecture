//
//  XXExpertProfileCell.m
//  Lecture
//
//  Created by 陈旭 on 16/1/10.
//  Copyright © 2016年 陈旭. All rights reserved.
//

#import "XXExpertProfileCell.h"

@interface XXExpertProfileCell ()

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

-(void)cellAutoLayoutHeight:(NSString *)str{
    self.expertFieldLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.expertFieldLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.expertFieldLabel.frame);
    self.expertFieldLabel.text = str;
}

@end
