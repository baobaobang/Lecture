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
@property (weak, nonatomic) IBOutlet UIView *toolBarView;


@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userVipView;
@property (weak, nonatomic) IBOutlet UIButton *userIconBtn;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end
@implementation XXQuestionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

        // 设置cell选中时不变色
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}
//
//- (void)awakeFromNib {
//    // Initialization code
//    // 初始化toolbar
//    XXQuestionToolbar *toolBar = [XXQuestionToolbar toolbar];
//    [self.toolBarView addSubview:toolBar];
//    self.toolBar = toolBar;
//}
//
//- (void)layoutSubviews{
//    [super layoutSubviews];
//    // 设置toolbar的frame
//    self.toolBar.frame = self.toolBarView.bounds;
//}
//
//
//// 给cell的子控件赋值
//- (void)setQuestion:(XXQuestion *)question{
//    
//    _question = question;
//    
//    self.toolBar.question = question;
//    XXUser *user = question.user;
//    
//    self.contentLabel.text = question.content;
//    self.userNameLabel.text = user.name;
//    self.userVipView.image = [UIImage imageNamed:user.vip];
//    [self.userIconBtn setBackgroundImage:[UIImage imageNamed:user.icon] forState:UIControlStateNormal];
//}

@end
