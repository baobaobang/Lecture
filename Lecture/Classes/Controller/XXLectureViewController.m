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
#define XXExpertProfileCellHeight 80
#define XXSelectedQuestionCellHeight 100

typedef enum{
    XXExpertProfileSection, // 专家简介
    XXSelectedQuestionSection // 精选提问
}XXTableViewSection;

@interface XXLectureViewController ()<UITableViewDataSource, UITableViewDelegate>
/**  */
@property (weak, nonatomic) IBOutlet XXPlayerView *playerView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *joinBtn;
/** 最近打开cell的indexPath */
@property (nonatomic, strong) NSIndexPath *currentOpenIndexPath;
/** 是否有cell处于打开状态，同一时间只能有一个cell处于打开状态 */
@property (nonatomic, assign) BOOL isOpenCell;

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
    
    //
    self.currentOpenIndexPath = [NSIndexPath indexPathForItem:-1 inSection:-1];
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
  
    if (indexPath.section == XXExpertProfileSection) {// 专家简介部分
        XXExpertProfileCell *expertCell = [XXExpertProfileCell expertProfileCellInTableView:tableView];
        if ([indexPath compare:self.currentOpenIndexPath] == NSOrderedSame && self.isOpenCell == YES) {
            // 展开cell，根据内容自动调整高度
            [expertCell cellAutoLayoutHeight];
            CGSize size = [expertCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
            return size.height + 1;
            
        }else{
            // 折叠cell，默认高度
            return XXExpertProfileCellHeight;
        }
    }else{// 精选提问部分
        XXSelectedQuestionCell *questionCell = [XXSelectedQuestionCell selectedQuestionCellInTableView:tableView];
        if ([indexPath compare:self.currentOpenIndexPath] == NSOrderedSame && self.isOpenCell == YES) {
            // 展开cell，根据内容自动调整高度
            
            [questionCell cellAutoLayoutHeight];
            CGSize size = [questionCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
            return size.height + 1;
        }else{
            // 折叠cell，默认高度
            return XXSelectedQuestionCellHeight;
        }
    }
}

#pragma mark - 估算的cell的高度
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == XXExpertProfileSection) {
        return XXExpertProfileCellHeight;
    }else{
        return XXSelectedQuestionCellHeight;
    }
}

#pragma mark - headerView的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}

#pragma mark - 点击cell后的反应
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // 判断是否要展开cell
    if ([indexPath compare:self.currentOpenIndexPath] == NSOrderedSame)
    {
        self.isOpenCell = !self.isOpenCell;
    }else{
        self.isOpenCell = YES;
    }
    self.currentOpenIndexPath = indexPath;
    
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

@end
