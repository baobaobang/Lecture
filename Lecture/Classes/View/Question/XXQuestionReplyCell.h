//
//  XXQuestionReplyCell.h
//  Lecture
//
//  Created by 陈旭 on 16/1/28.
//  Copyright © 2016年 陈旭. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXReply.h"
#import "XXQuestionReplyBaseCell.h"
#import "XXReplyPlayingIndex.h"

@class XXQuestionReplyCell;

@protocol XXQuestionReplyCellDelegate <NSObject>

//- (void)questionReplyCell:(XXQuestionReplyCell *)cell didClickPlayBtn:(XXButton *)btn;

@end


@interface XXQuestionReplyCell : XXQuestionReplyBaseCell

@property (nonatomic, strong) XXReply *reply;

@property (nonatomic, weak) id<XXQuestionReplyCellDelegate> delegate;

@property (nonatomic, strong) XXReplyPlayingIndex *clickedIndex; // 被点击的回复index
@property (nonatomic, strong) XXReplyPlayingIndex *index; // 本回复的index
@end
