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
        
        _questionFrames = [self loadDataFromPlist];
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
- (NSMutableArray *)loadDataFromPlist{
    //TODO: 后面改成从数据加载
    
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
}

- (void)dealloc{

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
    questionCell.toolbar.delegate = self;
    
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

#pragma mark - 点击toolbar上的按钮，XXQuestionToolbarDelegate
- (void)questionToolbar:(XXQuestionToolbar *)toolbar didClickBtnType:(XXQuestionToolbarButtonType)type{
    switch (type) {
        case XXQuestionToolbarButtonTypeShare:
            //TODO: 分享页面
            break;
        case XXQuestionToolbarButtonTypeReply:
            //TODO: 回复
            break;

        case XXQuestionToolbarButtonTypeUnlike:{
            
            
            NSUInteger oldRow = [self.questionFrames indexOfObject:toolbar.questionFrame];
            NSIndexPath *oldIndexPath = [NSIndexPath indexPathForRow:oldRow inSection:0];
            // 将question数组按照点赞数来排序，再刷新表格和cell顺序
            self.questionFrames = [self.questionFrames sortedArrayUsingSelector:@selector(compareAttitudesCount:)];
            NSUInteger newRow = [self.questionFrames indexOfObject:toolbar.questionFrame];
            NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:newRow inSection:0];
            
            // 动画交换两个cell的顺序
            [self.tableView moveRowAtIndexPath:oldIndexPath toIndexPath:newIndexPath];
            // 滚动到点赞所在cell的位置
            [self.tableView scrollToRowAtIndexPath:newIndexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];

            
            break;
        }
            
        default:
            break;
    }
}

@end
