//
//  XXXDraftBoxVC.m
//  Lecture
//
//  Created by mortal on 16/2/15.
//  Copyright © 2016年 陈旭. All rights reserved.
//

#import "XXXDraftBoxVC.h"
#import "XXXDraftBoxCell.h"
#import "XXXCoursewareBaseVC.h"
@interface XXXDraftBoxVC ()<XXXDraftBoxCellDelegate>

@end

@implementation XXXDraftBoxVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.mj_header.hidden = YES;
    self.tableView.mj_footer.hidden = YES;
    
    self.title = @"草稿箱";
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.dataArray = [XXXLectureModel AllLocalLectureModels];
    [self.tableView reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)back{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma -tableView代理,数据源

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    return 1;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return self.dataArray.count;
//}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [XXXDraftBoxCell cellForTableView:tableView with:self.dataArray[indexPath.row] delegate:self];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

/**
 *  删除选中的草稿
 *
 *  @param sender
 */
- (IBAction)deleteDraft:(UIButton *)sender {
    NSMutableArray *elementsTodelete = [NSMutableArray array];
    for (NSInteger i = 0 ; i< self.dataArray.count; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        XXXDraftBoxCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        
        //如果被选中  从本地删除
        if (cell.checkBox.selected) {
            [elementsTodelete addObject:cell.lectureModel];
        }
    }
    [XXXLectureModel deleteElements:elementsTodelete];
    self.dataArray = [XXXLectureModel AllLocalLectureModels];
    [self.tableView reloadData];
}
#pragma cell 编辑代理

/**
 *  继续编辑草稿
 *
 *  @param model 讲座模型
 */
- (void)editLecture:(XXXLectureModel *)model{
    
    XXXCoursewareBaseVC *cb = [[XXXCoursewareBaseVC alloc]init];
    cb.lectureModel = model;
    [self presentViewController:cb animated:YES completion:nil];
    
//    XXXCoursewareBaseVC *cb = [[XXXCoursewareBaseVC alloc]init];
//    cb.lectureModel = model;
//    [self presentViewController:cb animated:YES completion:nil];
}
@end
