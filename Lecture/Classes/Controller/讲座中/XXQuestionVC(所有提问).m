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
@property (nonatomic, strong) NSArray *frames;

@end

@implementation XXQuestionVC

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)headerRefreshAction
{
    NSUInteger size = 10;
    NSUInteger questionId = 0;
    // 陈旭接口-所有问题接口-加载新问题
    NSString *url = [NSString stringWithFormat:@"lectures/%@/questions?from=%ld&size=%ld", self.lecture.lectureId, questionId , size];
    
    [NetworkManager getWithApi:url params:nil success:^(id result) {
        NSArray *arr = result[@"data"];
        NSMutableArray *questions = [XXQuestion mj_objectArrayWithKeyValuesArray:arr];
        // question模型转为questionFrames模型
        self.questionFrames = [self questionFramesWithQuestions:questions];
        
        // 将最新的微博数据，添加到总数组的最前面
//        NSRange range = NSMakeRange(0, size);
//        NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:range];
//        [self.questionFrames insertObjects:questionFrames atIndexes:set];
        
        // 刷新表格
        [self.tableView reloadData];
        
        // 结束刷新
        [self endHeaderRefresh];
    } fail:^(NSError *error) {
        // 结束刷新
        [self endHeaderRefresh];
    }];
}

- (void)footerRefreshAction
{
    NSUInteger size = 10;
    // 计算questionId
    XXQuestionFrame *lastQuestionF = self.questionFrames.lastObject;
    NSInteger questionId = lastQuestionF.question.ID.integerValue - 10;
    
    // 陈旭接口-所有问题接口-加载旧问题
    NSString *url = [NSString stringWithFormat:@"lectures/%@/questions?from=%ld&size=%ld", self.lecture.lectureId, questionId, size];
    
    [NetworkManager getWithApi:url params:nil success:^(id result) {
        NSArray *arr = result[@"data"];
        NSMutableArray *questions = [XXQuestion mj_objectArrayWithKeyValuesArray:arr];
        // question模型转为questionFrames模型
        NSMutableArray *newFrames = [self questionFramesWithQuestions:questions];
        [self.questionFrames addObjectsFromArray:newFrames];
        
        // 将最新的微博数据，添加到总数组的最前面
        //        NSRange range = NSMakeRange(0, size);
        //        NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:range];
        //        [self.questionFrames insertObjects:questionFrames atIndexes:set];
        
        // 刷新表格
        [self.tableView reloadData];
        
        // 结束刷新
        [self endFooterRefresh];
    } fail:^(NSError *error) {
        // 结束刷新
        [self endFooterRefresh];
    }];
}

- (void)dealloc{
    XXTestLog;
}

@end