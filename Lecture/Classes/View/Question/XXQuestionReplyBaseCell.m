//
//  XXQuestionReplyBaseCell.m
//  Lecture
//
//  Created by 陈旭 on 16/2/26.
//  Copyright © 2016年 陈旭. All rights reserved.
//

#import "XXQuestionReplyBaseCell.h"

@implementation XXQuestionReplyBaseCell

- (void)awakeFromNib {
    
    self.backgroundColor =[UIColor clearColor];
    self.contentView.backgroundColor=[UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
