//
//  XXLectureHomeVC.m
//  Lecture
//
//  Created by 陈旭 on 16/1/29.
//  Copyright © 2016年 陈旭. All rights reserved.
//

#import "XXLectureHomeVC.h"
#import "XXLectureVC.h"
#import "XXLectureExpertOnlyVC.h"
#import "XXLectureSelectedQuestions.h"

@interface XXLectureHomeVC ()
@property (nonatomic, strong) XXLectureVC *lectureVc;

@property (nonatomic, assign) NSInteger fromIndex;
@end

@implementation XXLectureHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    /* 设置导航栏刷新item */
    UIImage *rightImage = [UIImage imageNamed:@"middle_nav_refresh"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:rightImage style:UIBarButtonItemStyleDone target:self action:@selector(rightItemClick)];

    // 添加子控制器
    XXLectureVC *lectureVc = [[XXLectureVC alloc] init];
    [self addChildViewController:lectureVc];
    lectureVc.view.frame = self.view.bounds;
    _lectureVc = lectureVc;
    
    lectureVc.lecture = self.lecture; // 传递讲座id数据
    
    XXLectureExpertOnlyVC *expertOnlyVc = [[XXLectureExpertOnlyVC alloc] init];
    [self addChildViewController:expertOnlyVc];
    expertOnlyVc.view.frame = CGRectMake(0, kXXStatusAndNavBarHeight, self.view.width, self.view.height - kXXStatusAndNavBarHeight);
    
    XXLectureSelectedQuestions *selectedQuestionVc = [[XXLectureSelectedQuestions alloc] init];
    [self addChildViewController:selectedQuestionVc];
    selectedQuestionVc.view.frame = CGRectMake(0, kXXStatusAndNavBarHeight, self.view.width, self.view.height - kXXStatusAndNavBarHeight);
    
    // 默认显示XXLectureVC
    [self.view addSubview:lectureVc.view];
    
    // navSegmentedControl
    NSArray *arr = [NSArray arrayWithObjects:@"全部信息", @"只看专家", @"精选提问", nil];
    UISegmentedControl *segment = [[UISegmentedControl alloc] initWithItems:arr];
//    [segment setTintColor:XXColorTint];
    [segment addTarget:self action:@selector(selected:) forControlEvents:UIControlEventValueChanged];
    segment.selectedSegmentIndex = 0;//选中第几个segment 一般用于初始化时选中
    self.navigationItem.titleView = segment;
}

- (void)rightItemClick
{
    
}

#pragma mark - 切换navSegmentedControl
- (void)selected:(UISegmentedControl *)segment{
    
    // 目标索引
    NSInteger toIndex = segment.selectedSegmentIndex;
    
    // 移除旧控制器的view
    UIViewController *oldVc = self.childViewControllers[self.fromIndex];
    
    // 显示新控制器的view
    UIViewController *newVc = self.childViewControllers[segment.selectedSegmentIndex];
    
    // 动画切换两个view
    [UIView transitionFromView:oldVc.view toView:newVc.view duration:0.5 options:UIViewAnimationOptionTransitionCrossDissolve completion:nil];
    //这个api 原理   ：
    //        1:[fromvalue.superview addSubview:tovalue];
    //        2:[fromvalue removeFromSuperview];
    
    // 重置之前索引
    self.fromIndex = toIndex;
}

@end
