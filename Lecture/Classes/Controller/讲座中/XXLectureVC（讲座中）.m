//
//  XXLectureVC.m
//  Lecture
//
//  Created by 陈旭 on 16/1/7.
//  Copyright © 2016年 陈旭. All rights reserved.
//

#import "XXLectureVC.h"
#import "XXNavigationController.h"
#import "XXPlayerVC.h"
#import "XXExpertProfileVC.h"
//#import "XXOnlineVC.h"
#import "XXQuestionVC.h"
#import "XXOnlineHeaderView.h"
#import "XXExpertProfileHeaderView.h"
#import "XXQuestionCreateVC.h"

@interface XXLectureVC ()<XXOnlineHeaderViewDelegate, XXExpertProfileHeaderViewDelegate>
@property (nonatomic, weak) XXPlayerVC *playerVc;
@property (nonatomic, weak) XXExpertProfileHeaderView *expertHeaderView;
@property (nonatomic, weak) XXExpertProfileVC *expertVc;
@property (nonatomic, weak) XXOnlineHeaderView *onlineHeaderView;
//@property (nonatomic, weak) XXOnlineVC *onlineVc;
@property (nonatomic, weak) XXQuestionVC *onlineVc;
@property (nonatomic, weak) XXButton *postQuestionBtn;


@end

@implementation XXLectureVC
#pragma mark - 懒加载

#pragma mark - 生命周期
- (void)viewDidLoad{
    
    self.view.backgroundColor = [UIColor clearColor];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // 设置导航栏
    [self setupNav];
    
    // 设置讲座图片和音频部分
    [self setupPlayerVc];
    
    // 设置专家简介头部
    [self setupExpertHeaderView];
    
    // 设置专家简介
    [self setupExpertVc];
    
    // 设置在线交流头部
    [self setupOnlineHeaderView];
    
    // 设置在线交流
    [self setupOnlineVc];
    
    // 设置我要提问按钮
    [self setupPostQuestionBtn];
    
    [XXNotificationCenter addObserver:self selector:@selector(landscapeBtnClick) name:XXLandscapeBtnDidClickNotification object:nil];
}

- (void)dealloc{
    [XXNotificationCenter removeObserver:self];
}

#pragma mark - 初始化

/**
 *  设置导航栏内容
 */
- (void)setupNav
{
    /* 设置左右item */
    UIImage *leftImage = [[UIImage imageNamed:@"back"] imageScaleToSize:CGSizeMake(20, 30)];
    UIImage *rightImage = [[UIImage imageNamed:@"Refresh"] imageScaleToSize:CGSizeMake(30, 30)];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(leftItemClick) bgImage:leftImage bgHighImage:leftImage];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(rightItemClick) bgImage:rightImage bgHighImage:rightImage];
}


- (void)setupPlayerVc{
    
    XXPlayerVC *playerVc = [[XXPlayerVC alloc] init];
    playerVc.view.x = 0;
    playerVc.view.y = kXXStatusAndNavBarHeight;
    playerVc.view.width = self.view.width;
    // playerVc.view的高度在计算完子view的高度后才能得到
    [self addChildViewController:playerVc];
    [self.view addSubview:playerVc.view];
    self.playerVc = playerVc;
}

// 专家简介头部
- (void)setupExpertHeaderView{
    
    XXExpertProfileHeaderView *expertHeaderView = [[[NSBundle mainBundle] loadNibNamed:@"XXExpertProfileHeaderView" owner:nil options:0]lastObject];
    expertHeaderView.x = 0;
    expertHeaderView.y = CGRectGetMaxY(self.playerVc.view.frame);
    expertHeaderView.height = kXXExpertHeaderViewHeight;
    expertHeaderView.width = self.view.width;
    
    expertHeaderView.delegate = self; // 设置代理
    [self.view addSubview:expertHeaderView];
    self.expertHeaderView = expertHeaderView;
}

// 专家简介
- (void)setupExpertVc{
    
    XXExpertProfileVC *expertVc = [[XXExpertProfileVC alloc] init];
    expertVc.view.x = 0;
    expertVc.view.y = CGRectGetMaxY(self.expertHeaderView.frame);
    expertVc.view.width = self.view.width;
    expertVc.view.height = kXXExpertTableViewHeight;
    [self addChildViewController:expertVc];
    [self.view addSubview:expertVc.view];
    self.expertVc = expertVc;
}

// 在线交流头部
- (void)setupOnlineHeaderView{
    XXOnlineHeaderView *onlineHeaderView = [[[NSBundle mainBundle] loadNibNamed:@"XXOnlineHeaderView" owner:nil options:0]lastObject];
    onlineHeaderView.x = 0;
    onlineHeaderView.y = CGRectGetMaxY(self.expertVc.view.frame);
    onlineHeaderView.height = kXXOnlineHeaderViewHeight;
    onlineHeaderView.width = self.view.width;
    
    onlineHeaderView.delegate = self; // 设置代理
    [self.view addSubview:onlineHeaderView];
    self.onlineHeaderView = onlineHeaderView;
}

// 在线交流
- (void)setupOnlineVc{
    
//    XXOnlineVC *onlineVc = [[XXOnlineVC alloc] init];
//    onlineVc.view.x = 0;
//    onlineVc.view.y = CGRectGetMaxY(self.onlineHeaderView.frame);
//    onlineVc.view.width = self.view.width;
//    onlineVc.view.height = self.view.height;
//    [self addChildViewController:onlineVc];
//    [self.view addSubview:onlineVc.view];
//    self.onlineVc = onlineVc;
    
    XXQuestionVC *onlineVc = [[XXQuestionVC alloc] init];
    onlineVc.view.x = 0;
    onlineVc.view.y = CGRectGetMaxY(self.onlineHeaderView.frame);
    onlineVc.view.width = self.view.width;
    onlineVc.view.height = self.view.height - onlineVc.view.y - kXXJoinButtonHeight;
    [self addChildViewController:onlineVc];
    [self.view addSubview:onlineVc.view];
    self.onlineVc = onlineVc;
}

// 设置提问按钮（最底部）
- (void)setupPostQuestionBtn{
    
    XXButton *postQuestionBtn = [[XXButton alloc] init];
    [postQuestionBtn setTitle:@"我要提问" forState:UIControlStateNormal];
    postQuestionBtn.backgroundColor = XXColorGreen;
    [postQuestionBtn addTarget:self action:@selector(postQuestion:) forControlEvents:UIControlEventTouchUpInside];
    postQuestionBtn.width = [UIScreen mainScreen].bounds.size.width;
    postQuestionBtn.height = kXXJoinButtonHeight;
    postQuestionBtn.x = 0;
    postQuestionBtn.y = self.view.height - postQuestionBtn.height;
    [self.view addSubview:postQuestionBtn];
    self.postQuestionBtn = postQuestionBtn;
}

// 提问
- (void)postQuestion:(XXButton *)btn{

    XXQuestionCreateVC *vc = [[XXQuestionCreateVC alloc] initWithNibName:@"XXQuestionCreateVC" bundle:nil];
//    vc.questionVC = self.questionVc;//TODO: 以后用通知或者代理来做
    vc.view.frame = self.view.frame;
    XXNavigationController *nav = [[XXNavigationController alloc] initWithRootViewController:vc];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}

- (void)leftItemClick
{
    [self.navigationController popViewControllerAnimated:YES];//TODO: 
}

- (void)rightItemClick
{
    NSLog(@"refresh");//TODO:
}


#pragma mark - 点击关注按钮 XXExpertProfileHeaderViewDelegate
- (void)expertProfileHeaderView:(XXExpertProfileHeaderView *)headerView didClickFollowBtn:(UIButton *)btn{
    XXLog(@"follow");//TODO:点击关注按钮
}

#pragma mark - 收起头部和展开头部 XXOnlineHeaderViewDelegate

- (void)onlineHeaderView:(XXOnlineHeaderView *)headerView didClickContractBtn:(UIButton *)btn
{
    if (!btn.selected) {
        [self hidePicView];
    }else{
        [self showPicView];
    }
}

- (void)hidePicView{

    // 需要上移的高度
    CGFloat heightOne = self.playerVc.playerPicView.height;
    CGFloat heightTwo = heightOne + kXXExpertHeaderViewHeight + kXXExpertTableViewHeight;
    
    [UIView animateWithDuration:kXXHideAndShowPicViewDuration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.playerVc.view.y -= heightOne;
        self.expertVc.view.y -= heightOne;
        self.onlineHeaderView.y -= heightTwo;
        self.onlineVc.view.y -= heightTwo;
        self.onlineVc.view.height += heightTwo;
        
    } completion:^(BOOL finished) {
    }];
}

- (void)showPicView{

    // 需要下移的高度
    CGFloat heightOne = self.playerVc.playerPicView.height;
    CGFloat heightTwo = heightOne + kXXExpertHeaderViewHeight + kXXExpertTableViewHeight;
    
    [UIView animateWithDuration:kXXHideAndShowPicViewDuration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.playerVc.view.y += heightOne;
        self.expertVc.view.y += heightOne;
        self.onlineHeaderView.y += heightTwo;
        self.onlineVc.view.y += heightTwo;
        self.onlineVc.view.height -= heightTwo;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)landscapeBtnClick{
    //TODO: 横竖屏切换
    XXTestLog;
}

@end
