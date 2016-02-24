//
//  XXQuestionBaseVC.h
//  Lecture
//
//  Created by 陈旭 on 16/1/29.
//  Copyright © 2016年 陈旭. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJExtension.h"
#import "XXQuestionFrame.h"
#import "MJRefresh.h"

@class XXUser, CXTextView;

@interface XXQuestionBaseVC : UITableViewController

/**
 *  模型数组
 */
@property (nonatomic, strong) NSMutableArray *questionFrames;

@property (nonatomic, weak) CXTextView *textView;// 回复的输入框

/**
 *  将XXQuestion模型转为XXQuestionFrame模型
 */
- (NSMutableArray *)questionFramesWithQuestions:(NSMutableArray *)questions;

- (void)headerRefreshAction;
- (void)footerRefreshAction;

- (void)endHeaderRefresh;

- (void)endFooterRefresh;
@end
