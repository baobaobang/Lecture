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
#import "XXLectureJoinVC.h"
#import "XXLectureHomeVC.h"
#import "DateFormatter.h"
#import "XXXLoginVC.h"
#import "EditUserInfoVC.h"

@interface XXXMainPageVC ()<XXXMakeLectureViewDelegate>

@property (nonatomic, strong) XXXMakeLectureView *mlv;

@end

@implementation XXXMainPageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"医讲堂";
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushFinishInfoVC) name:NOTIFICATION_TOFINISHINFO object:nil];

    
}
- (void)pushFinishInfoVC{
    [self.navigationController pushViewController:[[EditUserInfoVC alloc]init] animated:YES];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (isExpert) {
        _mlv = [[XXXMakeLectureView alloc]initWithFrame:CGRectMake(SWIDTH/2-25, SHEIGHT-100, 50, 100)];
        _mlv.delegate = self;
        [self.view addSubview:_mlv];
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
        tempArr = [self sortByDate:tempArr];
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
- (NSArray *)sortByDate:(NSArray *)dateArray{
    //NSMutableArray *temp = [NSMutableArray array];
    return [dateArray sortedArrayWithOptions:NSSortStable usingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSDate *date1 = [DateFormatter dateFromString:((XXXLectureModel *)obj1).startDate];
        NSDate *date2 = [DateFormatter dateFromString:((XXXLectureModel *)obj2).startDate];
        return [date2 compare:date1];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_mlv.isOpen) {
        [_mlv animateBtns:nil];
    }
    
    // 数据模型
    XXXLectureModel *lectureModel = self.dataArray[indexPath.row];
    if ([self isOldLecture:lectureModel]) {
        // 历史讲座：讲座中页面
        
        // 判断是否登录
        if (ACCESS_TOKEN) { // 如果已经登录
            
            XXLectureHomeVC *vc = [[XXLectureHomeVC alloc] init];
            vc.lecture = lectureModel;
            [self.navigationController pushViewController:vc animated:YES];
        }else{ // 如果未登录
            XXXLoginVC *vc = [[XXXLoginVC alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else{
        // 还没开始的讲座：讲座前页面
        XXLectureJoinVC *vc = [[XXLectureJoinVC alloc] init];
        vc.lecture = lectureModel;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (BOOL)isOldLecture:(XXXLectureModel *)lectureModel{
    NSString *dateStr = lectureModel.startDate;
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    //2016-02-29 18:38:29
    fmt.dateFormat = @"yyyy-MM-dd HH:mm";
    NSDate *date = [fmt dateFromString:dateStr];
    NSComparisonResult result = [date compare:[NSDate date]];
    if (result == NSOrderedAscending) {
        return YES;
    }else{
        return NO;
    }
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
            [SVProgressHUD showInfoWithStatus:@"敬请期待"];
            break;
//        case 3:
//        {
//            XXXDraftBoxVC *db = [[XXXDraftBoxVC alloc]init];
//            [self.navigationController pushViewController:db animated:YES];
//        }
//            break;
        default:
            break;
    }
    [mlview animateBtns:nil];
}

@end
