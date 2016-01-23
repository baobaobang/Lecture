//
//  XXQuestionViewController.m
//  Lecture
//
//  Created by 陈旭 on 16/1/20.
//  Copyright © 2016年 陈旭. All rights reserved.
//

#import "XXQuestionViewController.h"
#import "XXQuestionCell.h"
#import "XXQuestionHeaderView.h"
#import "XXQuestionToolbar.h"
#import <MJExtension.h>
#import "XXQuestionFrame.h"

static NSString * const questionHeaderId = @"questionHeaderId";
static NSString * const questionCellReuseId = @"QuestionCell";

@interface XXQuestionViewController ()<XXQuestionToolbarDelegate>

/**
 *  模型数组
 */
@property (nonatomic, strong) NSMutableArray *questionFrames;

@end

@implementation XXQuestionViewController

- (NSMutableArray *)questionFrames
{
    if (!_questionFrames) {
        NSArray *questions = [XXQuestion mj_objectArrayWithFilename:@"Questions.plist"];
        // 按照点赞数排序
        questions = [questions sortedArrayUsingSelector:@selector(compareAttitudesCount:)];
        self.questionFrames = [self questionFramesWithQuestions:questions];
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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 注册cell
    [self.tableView registerClass:[XXQuestionCell class] forCellReuseIdentifier:questionCellReuseId];
    
    // 注册headerview
    [self.tableView registerNib:[UINib nibWithNibName:@"XXQuestionHeaderView" bundle:nil] forHeaderFooterViewReuseIdentifier:questionHeaderId];
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
    
    questionCell.toolBar.delegate = self;
    
    // 给cell的子控件赋值
    questionCell.questionFrame = self.questionFrames[indexPath.row];
    
    return questionCell;
}

#pragma mark - 自定义的headerView
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    XXQuestionHeaderView *questionHeader = (XXQuestionHeaderView *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:questionHeaderId];
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

#pragma mark - XXQuestionToolbar的按钮被点击了
- (void)questionToolbar:(XXQuestionToolbar *)toolbar didClickBtnType:(XXQuestionToolbarButtonType)type{
    
    if (type == XXQuestionToolbarButtonTypeUnlike) {// 点击点赞按钮
        
        // 将将question数组排序按照点赞数来排序，再刷新表格和cell顺序
        NSUInteger oldRow = [self.questionFrames indexOfObject:toolbar.question];
        NSIndexPath *oldIndexPath = [NSIndexPath indexPathForRow:oldRow inSection:0];
        [self.tableView reloadRowsAtIndexPaths:@[oldIndexPath] withRowAnimation:UITableViewRowAnimationNone];// 先刷新点赞数目
        
        self.questionFrames = [self.questionFrames sortedArrayUsingSelector:@selector(compareAttitudesCount:)];
        NSUInteger newRow = [self.questionFrames indexOfObject:toolbar.question];
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:newRow inSection:0];
        
        [self.tableView moveRowAtIndexPath:oldIndexPath toIndexPath:newIndexPath];// 再移动cell顺序
        
    }else{// 点击分享和评论按钮
        
        XXQuestionCell *cell = (XXQuestionCell *)toolbar.superview.superview.superview;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
}

@end
