//
//  XXQuestionHeaderView.m
//  Lecture
//
//  Created by 陈旭 on 16/1/10.
//  Copyright © 2016年 陈旭. All rights reserved.
//

#import "XXQuestionHeaderView.h"

@interface XXQuestionHeaderView ()
@property (weak, nonatomic) IBOutlet UIButton *postQuestionBtn;

@end

@implementation XXQuestionHeaderView

- (void)awakeFromNib{
    [super awakeFromNib];
    
    // 设置我要提问按钮颜色
    self.postQuestionBtn.backgroundColor = HWQuestionTintColor;
}

+ (instancetype)headerView{
    return [[[NSBundle mainBundle] loadNibNamed:@"XXQuestionHeaderView" owner:nil options:nil] lastObject];
}

@end
