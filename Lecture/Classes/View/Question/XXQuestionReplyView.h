//
//  XXQuestionReplyView.h
//  Lecture
//
//  Created by 陈旭 on 16/1/28.
//  Copyright © 2016年 陈旭. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXQuestion.h"
#import "XXReplyPlayingIndex.h"

@interface XXQuestionReplyView : UIView
@property (nonatomic, strong) XXQuestion *question;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) XXReplyPlayingIndex *clickedIndex; // 被点击的回复index
+ (CGFloat)calculateReplyViewHeightWithReplys:(NSArray *)replys;
@end
