//
//  XXXMyLecturesVC.m
//  Lecture
//
//  Created by mortal on 16/2/18.
//  Copyright © 2016年 陈旭. All rights reserved.
//

#import "XXXMyLecturesVC.h"
#import "XXXDraftBoxCell.h"
#import "XXXCoursewareBaseVC.h"

@interface XXXMyLecturesVC ()<XXXDraftBoxCellDelegate>

@end

@implementation XXXMyLecturesVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的讲座";
}


- (void)headerRefreshAction{
    [super headerRefreshAction];
    [self getLectures:YES];
}
- (void)footerRefreshAction{
    [super footerRefreshAction];
    [self getLectures:NO];
}
#pragma -请求数据
- (void)getLectures:(BOOL) header{
    
    NSString *api = [NSString stringWithFormat:@"my/lectures?from=%ld&size=10",header?0:(long)self.dataArray.count];
    [NetworkManager getWithApi:api params:nil success:^(id result) {
        [self endHeaderRefresh];
        [self endFooterRefresh];
        NSArray *tempArr = [XXXLectureModel objectArrayWithArray:result[@"data"]];
        if (tempArr.count == 0) {
            [SVProgressHUD showInfoWithStatus:@"没有新数据"];
        }
        if (header) {
            [self.dataArray removeAllObjects];
        }
        [self.dataArray addObjectsFromArray:tempArr];
        
        [self.tableView reloadData];
    } fail:^(NSError *error) {
        
    }];
    
}
#pragma -tableView代理,数据源

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    return 1;
//}

//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return self.dataArray.count;
//}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    XXXDraftBoxCell *cell =  [XXXDraftBoxCell cellForTableView:tableView with:self.dataArray[indexPath.row] delegate:self];
    cell.checkBox.hidden = YES;
    [cell.edit setTitle:@"修改" forState:0];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma cell 编辑代理

/**
 *  修改讲座
 *
 *  @param model 讲座模型
 */
- (void)editLecture:(XXXLectureModel *)model{
    
//    [SVProgressHUD showInfoWithStatus:@"暂未开放"];
//    return;
    XXXCoursewareBaseVC *cb = [[XXXCoursewareBaseVC alloc]init];
    cb.lectureModel = model;
    [self presentViewController:cb animated:YES completion:nil];
}
@end
