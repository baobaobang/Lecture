
//
//  XXQuestionVC.m
//  Lecture
//
//  Created by 陈旭 on 16/1/20.
//  Copyright © 2016年 陈旭. All rights reserved.
//

#import "XXQuestionVC.h"
#import "MJRefresh.h"

@interface XXQuestionVC ()

@end

@implementation XXQuestionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [XXNotificationCenter addObserver:self selector:@selector(loadNewQuestions) name:XXLectureVCRefreshNotification object:nil];
}

- (void)dealloc{
    [XXNotificationCenter removeObserver:self];
}

// 点击导航栏的刷新按钮加载新问题
- (void)loadNewQuestions
{
    [self.tableView.mj_header beginRefreshing];
}

// 下拉加载最新的问题
- (void)headerRefreshAction
{
    // 陈旭接口-所有问题接口-加载新问题
    WS(weakSelf);
    
    NSString *url;
    XXQuestionFrame *firstQuestionF = [self.questionFrames firstObject];
    NSInteger questionId = firstQuestionF.question.ID.integerValue + 1;
    
    if (firstQuestionF) { // 不是第一次进入
        url = [NSString stringWithFormat:@"lectures/%@/questions?minId=%ld", self.lecture.lectureId, questionId];
    }else{
        url = [NSString stringWithFormat:@"lectures/%@/questions", self.lecture.lectureId];
    }
    [NetworkManager getWithApi:url params:nil success:^(id result) {
        NSArray *arr = result[@"data"];
        NSMutableArray *questions = [XXQuestion mj_objectArrayWithKeyValuesArray:arr];
        // question模型转为questionFrames模型
        NSArray *newFrames = [weakSelf questionFramesWithQuestions:questions];
        // 将最新的微博数据，添加到总数组的最前面
        NSRange range = NSMakeRange(0, newFrames.count);
        NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:range];
        [weakSelf.questionFrames insertObjects:newFrames atIndexes:set];
        
        // 刷新表格
        [weakSelf.tableView reloadData];
        
        // 结束刷新
        [weakSelf endHeaderRefresh];
    } fail:^(NSError *error) {
        // 结束刷新
        [weakSelf endHeaderRefresh];
        [MBProgressHUD showError:@"数据加载失败" toView:weakSelf.view];
    }];
}

// 上拉加载旧的问题
- (void)footerRefreshAction
{
    // 计算questionId
    XXQuestionFrame *lastQuestionF = self.questionFrames.lastObject;
    
    NSInteger questionId = lastQuestionF.question.ID.integerValue - 1;
    
    // 陈旭接口-所有问题接口-加载旧问题
    NSString *url = [NSString stringWithFormat:@"lectures/%@/questions?maxId=%ld", self.lecture.lectureId, questionId];
    WS(weakSelf);
    [NetworkManager getWithApi:url params:nil success:^(id result) {
        NSArray *arr = result[@"data"];
        
        if (arr.count == 0) {
            [MBProgressHUD showError:@"已无更多数据！" toView:self.view];
        }
        NSMutableArray *questions = [XXQuestion mj_objectArrayWithKeyValuesArray:arr];
        // question模型转为questionFrames模型
        NSMutableArray *newFrames = [weakSelf questionFramesWithQuestions:questions];
        [weakSelf.questionFrames addObjectsFromArray:newFrames];
        
        // 将最新的微博数据，添加到总数组的最前面
        //        NSRange range = NSMakeRange(0, size);
        //        NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:range];
        //        [self.questionFrames insertObjects:questionFrames atIndexes:set];
        
        // 刷新表格
        [weakSelf.tableView reloadData];
        
        // 结束刷新
        [weakSelf endFooterRefresh];

    } fail:^(NSError *error) {
        // 结束刷新
        [weakSelf endFooterRefresh];
        [MBProgressHUD showError:@"数据加载失败" toView:weakSelf.view];
    }];
}


@end