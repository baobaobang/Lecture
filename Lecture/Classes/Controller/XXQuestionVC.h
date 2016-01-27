//
//  XXQuestionVC.h
//  Lecture
//
//  Created by 陈旭 on 16/1/20.
//  Copyright © 2016年 陈旭. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XXUser, CXTextView;
@interface XXQuestionVC : UITableViewController

/**
 *  模型数组
 */
@property (nonatomic, strong) NSMutableArray *questionFrames;


@property (nonatomic, weak) CXTextView *textView;// 回复的输入框

/**
 *  从本地加载数据
 *
 *  @return 返回加载的模型数组
 */
- (NSMutableArray *)loadDataFromPlist;

@end


