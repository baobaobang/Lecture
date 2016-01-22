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

static NSString * const questionHeaderId = @"questionHeaderId";
static NSString * const questionCellReuseId = @"QuestionCell";

@interface XXQuestionViewController ()<XXQuestionToolbarDelegate>

// 数据
@property (nonatomic, strong) NSArray *questions;

@end

@implementation XXQuestionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 注册cell
    [self.tableView registerClass:[XXQuestionCell class] forCellReuseIdentifier:questionCellReuseId];
    
    // 注册headerview
    [self.tableView registerNib:[UINib nibWithNibName:@"XXQuestionHeaderView" bundle:nil] forHeaderFooterViewReuseIdentifier:questionHeaderId];
}

- (NSArray *)questions
{
    if (!_questions) {
        _questions = [XXQuestion objectArrayWithFilename:@"Questions.plist"];
        // 按照点赞数排序
        _questions = [_questions sortedArrayUsingSelector:@selector(compareAttitudesCount:)];
    }
    return _questions;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.questions.count;
}

// cell创建和数据
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    XXQuestionCell *questionCell = [[XXQuestionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:questionCellReuseId];
    
    questionCell.toolBar.delegate = self;
    
    // 给cell的子控件赋值
    questionCell.question = self.questions[indexPath.row];
    
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
//    XXQuestionCell *questionCell = [XXQuestionCell QuestionCellInTableView:tableView];
//    if ([indexPath compare:self.currentOpenIndexPath] == NSOrderedSame && self.isOpenCell == YES) {
//        // 展开cell，根据内容自动调整高度
//        XXQuestion *question = self.questions[indexPath.row];
//        [questionCell cellAutoLayoutHeight:question.content];
//        CGSize size = [questionCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
//        return MAX((size.height + 1), XXQuestionCellHeight);
//    }else{
//        // 折叠cell，默认高度
//        return XXQuestionCellHeight;
//    }
    return 80;
    
}

#pragma mark - 估算的cell的高度
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 80;
}


#pragma mark - 点击cell后的反应
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
}

#pragma mark - XXQuestionToolbar的按钮被点击了
- (void)questionToolbar:(XXQuestionToolbar *)toolbar didClickBtnType:(XXQuestionToolbarButtonType)type{
    
    if (type == XXQuestionToolbarButtonTypeUnlike) {// 点击点赞按钮
        
        // 将将question数组排序按照点赞数来排序，再刷新表格和cell顺序
        NSUInteger oldRow = [self.questions indexOfObject:toolbar.question];
        NSIndexPath *oldIndexPath = [NSIndexPath indexPathForRow:oldRow inSection:0];
        [self.tableView reloadRowsAtIndexPaths:@[oldIndexPath] withRowAnimation:UITableViewRowAnimationNone];// 先刷新点赞数目
        
        self.questions = [self.questions sortedArrayUsingSelector:@selector(compareAttitudesCount:)];
        NSUInteger newRow = [self.questions indexOfObject:toolbar.question];
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:newRow inSection:0];
        
        [self.tableView moveRowAtIndexPath:oldIndexPath toIndexPath:newIndexPath];// 再移动cell顺序
        
    }else{// 点击分享和评论按钮
        
        XXQuestionCell *cell = (XXQuestionCell *)toolbar.superview.superview.superview;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
}

@end
