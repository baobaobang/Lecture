//
//  XXQuestionReplyUserCell.m
//  Lecture
//
//  Created by 陈旭 on 16/2/26.
//  Copyright © 2016年 陈旭. All rights reserved.
//

#import "XXQuestionReplyUserCell.h"

@interface XXQuestionReplyUserCell()
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation XXQuestionReplyUserCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setReply:(XXReply *)reply{
    _reply = reply;
    
    self.contentLabel.text = [NSString stringWithFormat:@"%@: %@", reply.nickName, reply.text];
}

@end
