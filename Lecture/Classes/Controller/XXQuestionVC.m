//
//  XXQuestionVC.m
//  Lecture
//
//  Created by 陈旭 on 16/1/20.
//  Copyright © 2016年 陈旭. All rights reserved.
//

#import "XXQuestionVC.h"
#import "XXQuestionCell.h"
#import "XXQuestionHeaderView.h"
#import "XXQuestionToolbar.h"
#import <MJExtension.h>
#import "XXQuestionFrame.h"
#import "LZAlbumCreateVC.h"
#import "XXNavigationController.h"

static NSString * const questionHeaderId = @"questionHeaderId";
static NSString * const questionCellReuseId = @"QuestionCell";

@interface XXQuestionVC ()<XXQuestionToolbarDelegate, XXQuestionHeaderViewDelegate>

/**
 *  模型数组
 */
@property (nonatomic, strong) NSMutableArray *questionFrames;

@end

@implementation XXQuestionVC
#pragma mark - 懒加载

- (NSMutableArray *)questionFrames
{
    if (!_questionFrames) {
        // 字典转模型
        NSArray *questions = [XXQuestion mj_objectArrayWithFilename:@"Questions.plist"];
        // question模型转为questionFrames模型
        _questionFrames = [self questionFramesWithQuestions:questions];
        // 按照点赞数排序
        _questionFrames = [_questionFrames sortedArrayUsingSelector:@selector(compareAttitudesCount:)];
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
#pragma mark - 生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 注册cell
    [self.tableView registerClass:[XXQuestionCell class] forCellReuseIdentifier:questionCellReuseId];
    
    // 注册headerview
    [self.tableView registerNib:[UINib nibWithNibName:@"XXQuestionHeaderView" bundle:nil] forHeaderFooterViewReuseIdentifier:questionHeaderId];
    
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

#pragma mark - 自定义的headerView
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    XXQuestionHeaderView *questionHeader = (XXQuestionHeaderView *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:questionHeaderId];
    questionHeader.delegate = self;
    return questionHeader;
    
}

#pragma mark - headerView的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return XXHeaderViewHeight;
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

#pragma mark - XXQuestionHeaderViewDelegate 点击提问按钮
- (void)questionHeaderView:(XXQuestionHeaderView *)headerView didClickPostQuestionBtn:(UIButton *)btn
{
    LZAlbumCreateVC *vc = [[LZAlbumCreateVC alloc] initWithNibName:@"LZAlbumCreateVC" bundle:nil];
    vc.view.frame = self.view.frame;
    XXNavigationController *nav = [[XXNavigationController alloc] initWithRootViewController:vc];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}


@end
