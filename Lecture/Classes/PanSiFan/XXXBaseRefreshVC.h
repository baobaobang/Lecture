//
//  XXXBaseRefreshVC.h
//  Lecture
//
//  Created by mortal on 16/2/14.
//  Copyright © 2016年 陈旭. All rights reserved.
//

#import "XXXBaseVC.h"
#import "MJRefresh.h"
@interface XXXBaseRefreshVC : XXXBaseVC

@property (weak,nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;//数据源


- (void)headerRefreshAction;
- (void)footerRefreshAction;

- (void)endHeaderRefresh;

- (void)endFooterRefresh;


@end
