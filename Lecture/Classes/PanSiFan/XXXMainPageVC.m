//
//  XXXMainPageVC.m
//  lecture
//
//  Created by mortal on 16/1/26.
//  Copyright © 2016年 禾医健康科技. All rights reserved.
//

#import "XXXMainPageVC.h"
#import "XXXCoursewareBaseVC.h"
#import "MainPageLectureCell.h"
#import "XXXMakeLectureView.h"
#import "XXXLectureModel.h"
#import "XXXDraftBoxVC.h"
#import "AFNetworking.h"
#import "XXXApplyLectureVC.h"
#import "XXXMyLecturesVC.h"
#import "AudioTool.h"
@interface XXXMainPageVC ()<XXXMakeLectureViewDelegate>

@end

@implementation XXXMainPageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"医讲堂";
    
}


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (isExpert) {
        XXXMakeLectureView *mlv = [[XXXMakeLectureView alloc]initWithFrame:CGRectMake(SWIDTH/2-25, SHEIGHT-100, 50, 100)];
        mlv.delegate = self;
        [self.view addSubview:mlv];
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
- (void)getLectures:(BOOL)header{
    NSString *api = [NSString stringWithFormat:@"lectures?from=%ld&size=10",header?0:(long)self.dataArray.count];
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
//    return 0;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return [MainPageLectureCell cellForTableView:tableView with:self.dataArray[indexPath.row]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    XXXLectureModel *lectureModel = self.dataArray[indexPath.row];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)XXXMakeLectureView:(XXXMakeLectureView *)mlview clickedIndex:(NSInteger)index{
    switch (index) {
        case 0:
        {
            XXXApplyLectureVC *al = [[XXXApplyLectureVC alloc]init];
            [self presentViewController:al animated:YES completion:nil];
        }
            break;
        case 1:
        {
            XXXMyLecturesVC *ml = [[XXXMyLecturesVC alloc]init];
            [self.navigationController pushViewController:ml animated:YES];
        }
            break;
        case 2:
            
            break;
        case 3:
        {
            XXXDraftBoxVC *db = [[XXXDraftBoxVC alloc]init];
            [self.navigationController pushViewController:db animated:YES];
        }
            break;
        default:
            break;
    }
    [mlview animateBtns:nil];
}

@end
