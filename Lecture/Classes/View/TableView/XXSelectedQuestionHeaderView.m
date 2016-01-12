//
//  XXSelectedQuestionHeaderView.m
//  Lecture
//
//  Created by 陈旭 on 16/1/10.
//  Copyright © 2016年 陈旭. All rights reserved.
//

#import "XXSelectedQuestionHeaderView.h"

@interface XXSelectedQuestionHeaderView ()
@property (weak, nonatomic) IBOutlet UIButton *postQuestionBtn;

@end

@implementation XXSelectedQuestionHeaderView

- (void)awakeFromNib{
    [super awakeFromNib];
    
    // 设置我要提问按钮颜色
    self.postQuestionBtn.backgroundColor = HWSelectedQuestionTintColor;
}

+ (instancetype)headerView{
    return [[[NSBundle mainBundle] loadNibNamed:@"XXSelectedQuestionHeaderView" owner:nil options:nil] lastObject];
}

@end
