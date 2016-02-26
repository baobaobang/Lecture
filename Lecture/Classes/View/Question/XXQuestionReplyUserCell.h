//
//  XXQuestionReplyUserCell.h
//  Lecture
//
//  Created by 陈旭 on 16/2/26.
//  Copyright © 2016年 陈旭. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXReply.h"
#import "XXQuestionReplyBaseCell.h"

@interface XXQuestionReplyUserCell : XXQuestionReplyBaseCell
@property (nonatomic, strong) XXReply *reply;
@end
