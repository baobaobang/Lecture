//
//  XXQuestionVC.m
//  Lecture
//
//  Created by 陈旭 on 16/1/20.
//  Copyright © 2016年 陈旭. All rights reserved.
//

#import "XXQuestionVC.h"
#import "XXQuestionCell.h"
#import "XXQuestionToolbar.h"
#import <MJExtension.h>
#import "XXQuestionFrame.h"

static NSString * const questionCellReuseId = @"QuestionCell";

@interface XXQuestionVC ()<XXQuestionToolbarDelegate>


@end

@implementation XXQuestionVC
#pragma mark - 懒加载


- (NSMutableArray *)questionFrames
{
    if (!_questionFrames) {
        
        _questionFrames = [self loadData];
    }
    return _questionFrames;
}
/**
 *  将XXQuestion模型转为XXQuestionFrame模型
 */
- (NSArray *)questionFramesWithQuestions:(NSArray *)questions
{
    NSMutableArray *frames = [NSMutableArray array];
    for (XXQuestion *question in questions) {
        XXQuestionFrame *f = [[XXQuestionFrame alloc] init];
        f.question = question;
        [frames addObject:f];
    }
    return frames;
}

#pragma mark - 从本地加载数据
- (NSMutableArray *)loadData{
    
    // 字典转模型
    // 方式一：从document目录下加载plist
//    NSString *docmentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    //    NSString *plistPath = [docmentPath stringByAppendingPathComponent:@"Questions.plist"];
    
    // 方式二：从mainBundle目录下加载plist
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Questions.plist" ofType:nil];
    
    NSArray *questions = [XXQuestion mj_objectArrayWithFile:plistPath];
    // question模型转为questionFrames模型
    NSMutableArray *questionFrames = [self questionFramesWithQuestions:questions];
    // 按照点赞数排序
    questionFrames = [questionFrames sortedArrayUsingSelector:@selector(compareAttitudesCount:)];
    
    return questionFrames;
}
#pragma mark - 生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 注册cell
    [self.tableView registerClass:[XXQuestionCell class] forCellReuseIdentifier:questionCellReuseId];
    
    // 添加观察者
    [XXNotificationCenter addObserver:self selector:@selector(questionToolbarShareBtnClicked:) name:XXQuestionToolbarShareButtonClick object:nil];
    [XXNotificationCenter addObserver:self selector:@selector(questionToolbarUnlikeBtnClicked:) name:XXQuestionToolbarUnlikeButtonClick object:nil];
    
}

- (void)dealloc{
    [XXNotificationCenter removeObserver:self];
}

#pragma mark - 处理Toolbar上的按钮被点击后发来的通知
- (void)questionToolbarShareBtnClicked:(NSNotification *)noti{
    XXQuestionToolbar * toolbar = noti.userInfo[@"toolbar"];
    XXQuestionCell *cell = (XXQuestionCell *)toolbar.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)questionToolbarUnlikeBtnClicked:(NSNotification *)noti{
    // 将将question数组排序按照点赞数来排序，再刷新表格和cell顺序
    XXQuestionToolbar * toolbar = noti.userInfo[@"toolbar"];
    NSUInteger oldRow = [self.questionFrames indexOfObject:toolbar.questionFrame];
    NSIndexPath *oldIndexPath = [NSIndexPath indexPathForRow:oldRow inSection:0];
    [self.tableView reloadRowsAtIndexPaths:@[oldIndexPath] withRowAnimation:UITableViewRowAnimationNone];// 先刷新点赞数目
    
    self.questionFrames = [self.questionFrames sortedArrayUsingSelector:@selector(compareAttitudesCount:)];
    NSUInteger newRow = [self.questionFrames indexOfObject:toolbar.questionFrame];
    NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:newRow inSection:0];
    
    [self.tableView moveRowAtIndexPath:oldIndexPath toIndexPath:newIndexPath];// 再移动cell顺序
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.questionFrames.count;
}

// cell创建和数据
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    XXQuestionCell *questionCell = [[XXQuestionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:questionCellReuseId];
    
    // 设置toolBar的代理
    questionCell.toolBar.delegate = self;
    
    // 给cell的子控件赋值
    questionCell.questionFrame = self.questionFrames[indexPath.row];
    
    return questionCell;
}

#pragma mark - cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XXQuestionFrame *frame = self.questionFrames[indexPath.row];
    return frame.cellHeight;
    
}

#pragma mark - 点击cell后的反应
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
}


@end
