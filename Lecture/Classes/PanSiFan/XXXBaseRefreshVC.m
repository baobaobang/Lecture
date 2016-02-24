//
//  XXXBaseRefreshVC.m
//  Lecture
//
//  Created by mortal on 16/2/14.
//  Copyright © 2016年 陈旭. All rights reserved.
//

#import "XXXBaseRefreshVC.h"

@interface XXXBaseRefreshVC ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UIImageView *noDataImage;
@end

@implementation XXXBaseRefreshVC


- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    WS(weakSelf);
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf headerRefreshAction];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf footerRefreshAction];
    }];
//    self.tableView.mj_header.hidden = YES;
//    self.tableView.mj_footer.hidden = YES;
    [self.tableView.mj_header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)headerRefreshAction{
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self endHeaderRefresh];
//    });
}
- (void)footerRefreshAction{
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self endFooterRefresh];
//    });
}

- (void)endHeaderRefresh{
    [self.tableView.mj_header endRefreshing];
}

- (void)endFooterRefresh{
    [self.tableView.mj_footer endRefreshing];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.dataArray.count == 0) {
        self.noDataImage.layer.opacity = 1;
    }else{
        self.noDataImage.layer.opacity = 0;
    }
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

- (UIImageView *)noDataImage{
    if (!_noDataImage) {
        _noDataImage = [[UIImageView alloc]initWithFrame:CGRectMake(SWIDTH/2-50, SHEIGHT/2-150, 100, 150)];
        _noDataImage.image = [UIImage imageNamed:@"nodata"];
        [self.tableView addSubview:_noDataImage];
    }
    return _noDataImage;
}
@end
