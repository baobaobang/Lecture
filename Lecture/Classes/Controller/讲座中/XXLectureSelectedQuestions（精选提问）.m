//
//  XXLectureSelectedQuestions.m
//  Lecture
//
//  Created by 陈旭 on 16/1/29.
//  Copyright © 2016年 陈旭. All rights reserved.
//

#import "XXLectureSelectedQuestions.h"

@interface XXLectureSelectedQuestions ()

@end

@implementation XXLectureSelectedQuestions

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.view.frame = CGRectMake(0, kXXStatusAndNavBarHeight, XXScreenWidth, XXScreenHeight - kXXStatusAndNavBarHeight);
    
    [XXNotificationCenter addObserver:self selector:@selector(loadNewQuestions) name:XXLectureSelectedQuestionsVCRefreshNotification object:nil];
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
    NSUInteger size = 5;
    NSUInteger questionId = 0;
    // 陈旭接口-所有问题接口-加载新问题
    WS(weakSelf);
    NSString *url = [NSString stringWithFormat:@"lectures/%@/questions?from=%ld&size=%ld", self.lecture.lectureId, questionId , size];
    
    [NetworkManager getWithApi:url params:nil success:^(id result) {
        NSArray *arr = result[@"data"];
        NSMutableArray *questions = [XXQuestion mj_objectArrayWithKeyValuesArray:arr];
        // question模型转为questionFrames模型
        weakSelf.questionFrames = [weakSelf questionFramesWithQuestions:questions];
        
        // 将最新的微博数据，添加到总数组的最前面
        //        NSRange range = NSMakeRange(0, size);
        //        NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:range];
        //        [self.questionFrames insertObjects:questionFrames atIndexes:set];
        
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

// 上拉加载旧的问题-因为没有旧的提问就直接结束刷新
- (void)footerRefreshAction
{
    [self endFooterRefresh];
}



@end
