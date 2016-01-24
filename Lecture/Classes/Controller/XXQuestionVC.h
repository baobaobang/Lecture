//
//  XXQuestionVC.h
//  Lecture
//
//  Created by 陈旭 on 16/1/20.
//  Copyright © 2016年 陈旭. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XXUser;
@interface XXQuestionVC : UITableViewController

/**
 *  模型数组
 */
@property (nonatomic, strong) NSMutableArray *questionFrames;


/**
 *  从本地加载数据
 *
 *  @return 返回加载的模型数组
 */
- (NSMutableArray *)loadData;

@end


