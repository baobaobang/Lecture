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

@property (nonatomic, assign) NSInteger fromIndex;
@end

@implementation XXLectureHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];

    // 添加子控制器
    XXLectureVC *lectureVc = [[XXLectureVC alloc] init];
    [self addChildViewController:lectureVc];
    
    XXLectureExpertOnlyVC *expertOnlyVc = [[XXLectureExpertOnlyVC alloc] init];
    [self addChildViewController:expertOnlyVc];
    
    XXLectureSelectedQuestions *selectedQuestionVc = [[XXLectureSelectedQuestions alloc] init];
    [self addChildViewController:selectedQuestionVc];
    
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
