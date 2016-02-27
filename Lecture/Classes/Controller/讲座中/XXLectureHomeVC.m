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
@property (nonatomic, weak) XXLectureVC *lectureVc;

@property (nonatomic, assign) NSInteger fromIndex;
@property (nonatomic, weak) UISegmentedControl *segment;
@end

@implementation XXLectureHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    /* 设置导航栏刷新item */
    UIImage *rightImage = [UIImage imageNamed:@"middle_nav_refresh"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:rightImage style:UIBarButtonItemStyleDone target:self action:@selector(rightItemClick)];

    // 添加子控制器
    // 全部信息
    XXLectureVC *lectureVc = [[XXLectureVC alloc] init];
    [self addChildViewController:lectureVc];
    lectureVc.view.frame = self.view.bounds;
    _lectureVc = lectureVc;
    lectureVc.lecture = self.lecture; // 传递讲座id数据
    
    // 只看专家
    XXLectureExpertOnlyVC *expertOnlyVc = [[XXLectureExpertOnlyVC alloc] init];
    [self addChildViewController:expertOnlyVc];
//    expertOnlyVc.view.frame = CGRectMake(0, kXXStatusAndNavBarHeight, self.view.width, self.view.height - kXXStatusAndNavBarHeight);// 不能再这里设置frame，否则会直接加载它的view
    expertOnlyVc.lecture = self.lecture; // 传递讲座id数据
    
    // 精选提问
    XXLectureSelectedQuestions *selectedQuestionVc = [[XXLectureSelectedQuestions alloc] init];
    [self addChildViewController:selectedQuestionVc];
//    selectedQuestionVc.view.frame = CGRectMake(0, kXXStatusAndNavBarHeight, self.view.width, self.view.height - kXXStatusAndNavBarHeight);
    selectedQuestionVc.lecture = self.lecture; // 传递讲座id数据
    
    // 默认显示XXLectureVC
    [self.view addSubview:lectureVc.view];
    
    // navSegmentedControl
    NSArray *arr = [NSArray arrayWithObjects:@"全部信息", @"只看专家", @"精选提问", nil];
    UISegmentedControl *segment = [[UISegmentedControl alloc] initWithItems:arr];
//    [segment setTintColor:XXColorTint];
    [segment addTarget:self action:@selector(selected:) forControlEvents:UIControlEventValueChanged];
    segment.selectedSegmentIndex = 0;//选中第几个segment 一般用于初始化时选中
    self.fromIndex = 0;
    self.navigationItem.titleView = segment;
    self.segment = segment;
}

- (void)dealloc{
    
}

#pragma mark - 点击刷新按钮
- (void)rightItemClick{
    switch (self.segment.selectedSegmentIndex) {
        case 0://全部信息
            [XXNotificationCenter postNotificationName:XXLectureVCRefreshNotification object:nil];
            break;
        case 1://只看专家
            [XXNotificationCenter postNotificationName:XXLectureExpertOnlyVCRefreshNotification object:nil];
            break;
        case 2://精选提问
            [XXNotificationCenter postNotificationName:XXLectureSelectedQuestionsVCRefreshNotification object:nil];
            break;
            
        default:
            break;
    }
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
