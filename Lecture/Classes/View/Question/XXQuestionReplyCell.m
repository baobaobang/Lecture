//
//  XXQuestionReplyCell.m
//  Lecture
//
//  Created by 陈旭 on 16/1/28.
//  Copyright © 2016年 陈旭. All rights reserved.
//

#import "XXQuestionReplyCell.h"
#import "XXReply.h"


@interface XXQuestionReplyCell ()
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;

@end

@implementation XXQuestionReplyCell

- (void)awakeFromNib {
    self.backgroundColor =[UIColor clearColor];
    self.contentView.backgroundColor=[UIColor clearColor];
}

- (void)setReply:(XXReply *)reply{
    _reply = reply;
    
    self.userNameLabel.text = reply.expert.name;
}

@end
