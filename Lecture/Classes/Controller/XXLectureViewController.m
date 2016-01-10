//
//  XXLectureViewController.m
//  Lecture
//
//  Created by 陈旭 on 16/1/7.
//  Copyright © 2016年 陈旭. All rights reserved.
//

#import "XXLectureViewController.h"
#import "XXPlayerView.h"
#import "HWNavigationController.h"
#import "XXExpertProfileCell.h"
#import "XXExpertProfileHeaderView.h"
#import "XXSelectedQuestionCell.h"
#import "XXSelectedQuestionHeaderView.h"

#define XXNavigationTitleFont 18

typedef enum{
    XXExpertProfileSection, // 专家简介
    XXSelectedQuestionSection // 精选提问
}XXTableViewSection;

@interface XXLectureViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet XXPlayerView *playerView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *joinBtn;

@end

@implementation XXLectureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置导航栏内容
    [self setupNav];
    
    // 初始化XXPlayerView
    XXPlayerView *playerView = [XXPlayerView playerView];
    [self.playerView addSubview:playerView];
    
    // 设置报名活动按钮颜色
    self.joinBtn.backgroundColor = HWColor(75, 217, 130);
}

/**
 *  设置导航栏内容
 */
- (void)setupNav
{
    /* 设置导航栏上面的内容 */
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(leftItemClick) image:@"navigationbar_friendsearch" highImage:@"navigationbar_friendsearch_highlighted"];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(rightItemClick) image:@"navigationbar_pop" highImage:@"navigationbar_pop_highlighted"];
    
    /* 导航栏标题 */
    self.title = @"公益讲堂";
    NSMutableDictionary *attr = [NSMutableDictionary dictionary];
    attr[NSFontAttributeName] = [UIFont systemFontOfSize:XXNavigationTitleFont];
    attr[NSForegroundColorAttributeName] = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:attr];
    
    /* 设置导航栏的背景颜色 */
    self.navigationController.navigationBar.barTintColor = HWTintColor;
}

- (void)leftItemClick
{
    NSLog(@"leftItemClick");
}

- (void)rightItemClick
{
    NSLog(@"rightItemClick");
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == XXExpertProfileSection) {
        return 1;
    }else{
        return 5;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == XXExpertProfileSection) {
        XXExpertProfileCell *expertCell = [XXExpertProfileCell expertProfileCellInTableView:tableView];
        return expertCell;
    }else{
        XXSelectedQuestionCell *selectedCell = [XXSelectedQuestionCell selectedQuestionCellInTableView:tableView];
        return selectedCell;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == XXExpertProfileSection) {
        return [XXExpertProfileHeaderView headerView];
    }else{
        return [XXSelectedQuestionHeaderView headerView];
    }
}

#pragma mark - cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == XXExpertProfileSection) {
        return 80;
    }else{
        return 80;
    }
}

#pragma mark - headerView的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}

@end
