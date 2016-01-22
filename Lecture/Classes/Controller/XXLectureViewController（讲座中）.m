//
//  XXLectureViewController.m
//  Lecture
//
//  Created by 陈旭 on 16/1/7.
//  Copyright © 2016年 陈旭. All rights reserved.
//

#import "XXLectureViewController.h"
#import "HWNavigationController.h"
#import "XXPlayerViewController.h"
#import "XXExpertProfileViewController.h"
#import "XXQuestionViewController.h"

@interface XXLectureViewController ()
@property (nonatomic, weak) XXPlayerViewController *playerVc;
@property (nonatomic, weak) XXExpertProfileViewController *expertVc;
@property (nonatomic, weak) XXQuestionViewController *questionVc;
@property (nonatomic, weak) XXButton *postQuestionBtn;

@end

@implementation XXLectureViewController
#pragma mark - 懒加载

#pragma mark - 生命周期
- (void)viewDidLoad{
    
    // 设置导航栏
    [self setupNav];
    
    // 设置讲座图片和音频部分
    [self setupPlayerVc];
    
    // 设置专家简介
    [self setupExpertVc];
    
    // 设置在线交流部分
    [self setupQuestionVc];
    
    // 设置我要提问按钮
    [self setupPostQuestionBtn];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // 注册观察者，接收XXExpertProfileHeaderView发出的通知
    [HWNotificationCenter addObserver:self selector:@selector(hidePlayerPicView) name:XXPlayerPicViewWillHide object:nil];
    [HWNotificationCenter addObserver:self selector:@selector(showPlayerPicView) name:XXPlayerPicViewWillShow object:nil];
}

- (void)dealloc{
    [HWNotificationCenter removeObserver:self];
}

#pragma mark - 收到通知后的处理

- (void)hidePlayerPicView{
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.view.y -= self.playerVc.playerPicView.height;
        // 在上移控制器的view的时候，同步下移报名按钮，这样就可以保证报名按钮一直在最下方
        self.postQuestionBtn.y += self.playerVc.playerPicView.height;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)showPlayerPicView{
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.view.y += self.playerVc.playerPicView.height;
        self.postQuestionBtn.y -= self.playerVc.playerPicView.height;
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - 初始化

/**
 *  设置导航栏内容
 */
- (void)setupNav
{
    /* 设置导航栏上面的内容 */
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(leftItemClick) image:@"navigationbar_friendsearch" highImage:@"navigationbar_friendsearch_highlighted"];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(rightItemClick) image:@"navigationbar_pop" highImage:@"navigationbar_pop_highlighted"];

    
    /* 设置导航栏的背景颜色 */
    // 这里设置无效
//    self.navigationController.navigationBar.barTintColor = HWTintColor;
}

- (void)setupPlayerVc{
    
    XXPlayerViewController *playerVc = [[XXPlayerViewController alloc] init];
    playerVc.view.x = 0;
    playerVc.view.y = XXStatusAndNavBarHeight;
    playerVc.view.width = self.view.width;
    // playerVc.view的高度在计算完子view的高度后才能得到
    [self addChildViewController:playerVc];
    [self.view addSubview:playerVc.view];
    self.playerVc = playerVc;
}

- (void)setupExpertVc{
    
    XXExpertProfileViewController *expertVc = [[XXExpertProfileViewController alloc] init];
    expertVc.view.x = 0;
    expertVc.view.y = CGRectGetMaxY(self.playerVc.view.frame);
    expertVc.view.width = self.view.width;
    expertVc.view.height = XXExpertProfileViewHeight;
    [self addChildViewController:expertVc];
    [self.view addSubview:expertVc.view];
    self.expertVc = expertVc;
}


- (void)setupQuestionVc{
    
    XXQuestionViewController *questionVc = [[XXQuestionViewController alloc] init];
    questionVc.view.x = 0;
    questionVc.view.y = CGRectGetMaxY(self.expertVc.view.frame);
    questionVc.view.width = self.view.width;
    questionVc.view.height = self.view.height;
    [self addChildViewController:questionVc];
    [self.view addSubview:questionVc.view];
    self.questionVc = questionVc;
}

// 设置报名活动按钮
- (void)setupPostQuestionBtn{
    
    XXButton *postQuestionBtn = [[XXButton alloc] init];
    [postQuestionBtn setTitle:@"我要提问" forState:UIControlStateNormal];
    postQuestionBtn.backgroundColor = HWQuestionTintColor;
    [postQuestionBtn addTarget:self action:@selector(joinBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    postQuestionBtn.width = [UIScreen mainScreen].bounds.size.width;
    postQuestionBtn.height = XXJoinButtonHeight;
    postQuestionBtn.x = 0;
    postQuestionBtn.y = self.view.height - postQuestionBtn.height;
    [self.view addSubview:postQuestionBtn];
    self.postQuestionBtn = postQuestionBtn;
}


- (void)joinBtnClick:(XXButton *)btn{
    
}

- (void)leftItemClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightItemClick
{
    NSLog(@"rightItemClick");
}

@end
