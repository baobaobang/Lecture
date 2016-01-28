//
//  XXQuestionReplyCell.h
//  Lecture
//
//  Created by 陈旭 on 16/1/28.
//  Copyright © 2016年 陈旭. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XXReply, XXQuestionReplyCell;

@protocol XXQuestionReplyCellDelegate <NSObject>

//- (void)questionReplyCell:(XXQuestionReplyCell *)cell didClickPlayBtn:(XXButton *)btn;

@end
@interface XXQuestionReplyCell : UITableViewCell
@property (nonatomic, strong) XXReply *reply;

@property (nonatomic, weak) id<XXQuestionReplyCellDelegate> delegate;
@end
