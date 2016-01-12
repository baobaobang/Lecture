//
//  XXQuestionCell.m
//  Lecture
//
//  Created by 陈旭 on 16/1/10.
//  Copyright © 2016年 陈旭. All rights reserved.
//

#import "XXQuestionCell.h"
#import "XXQuestionToolbar.h"
#import "XXQuestion.h"


@interface XXQuestionCell ()
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIView *toolBarView;



@end
@implementation XXQuestionCell

//创建自定义可重用的cell对象
+ (instancetype)QuestionCellInTableView:(UITableView *)tableView{
    static NSString *reuseId = @"QuestionCell";
    XXQuestionCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"XXQuestionCell" owner:nil options:nil] lastObject];
        // 设置cell选中时不变色
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}


- (void)awakeFromNib {
    // Initialization code
    // 初始化toolbar
    XXQuestionToolbar *toolBar = [XXQuestionToolbar toolbar];
    [self.toolBarView addSubview:toolBar];
    self.toolBar = toolBar;
    
    // 设置屏蔽按钮的背景颜色和字体颜色
    self.shieldBtn.backgroundColor = HWQuestionTintColor;
    [self.shieldBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    // 设置toolbar的frame
    self.toolBar.frame = self.toolBarView.bounds;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

// cell高度自动适应label内容
-(void)cellAutoLayoutHeight:(NSString *)text{
    self.contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.contentLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.contentLabel.frame);
    self.contentLabel.text = text;
}

- (void)setQuestion:(XXQuestion *)question{
    _question = question;
    
    
}

@end
