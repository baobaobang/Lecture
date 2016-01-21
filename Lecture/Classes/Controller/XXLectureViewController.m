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

#define XXNavigationTitleFont 18

@interface XXLectureViewController ()
@property (nonatomic, weak) XXPlayerViewController *playerVc;
@property (nonatomic, weak) XXExpertProfileViewController *expertVc;
@property (nonatomic, weak) XXQuestionViewController *questionVc;
@property (nonatomic, weak) XXButton *joinBtn;

@end

@implementation XXLectureViewController

- (void)viewDidLoad{
    
    // 设置导航栏
    [self setupNav];
    
    // 设置playerVc
    [self setupPlayerVc];
    
    // 设置expertVc
    [self setupExpertVc];
    
    // 设置questionVc
    [self setupQuestionVc];
    
    // 设置joinBtn
    [self setupJoinBtn];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
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

- (void)setupPlayerVc{
    
    XXPlayerViewController *playerVc = [[XXPlayerViewController alloc] init];
    playerVc.view.x = 0;
    playerVc.view.y = 64;
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
    expertVc.view.height = 115;
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
- (void)setupJoinBtn{
    
    XXButton *joinBtn = [[XXButton alloc] init];
    [joinBtn setTitle:@"报名活动" forState:UIControlStateNormal];
    joinBtn.backgroundColor = HWQuestionTintColor;
    [joinBtn addTarget:self action:@selector(joinBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    joinBtn.width = self.view.width;
    joinBtn.height = 44;
    joinBtn.x = 0;
    joinBtn.y = self.view.height - joinBtn.height;
    [self.view addSubview:joinBtn];
    self.joinBtn = joinBtn;
}


- (void)joinBtnClick:(XXButton *)btn{
    
}


- (void)leftItemClick
{
    NSLog(@"leftItemClick");
}

- (void)rightItemClick
{
    NSLog(@"rightItemClick");
}

@end
