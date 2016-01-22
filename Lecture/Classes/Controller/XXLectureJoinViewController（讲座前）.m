//
//  XXLectureJoinViewController.m
//  Lecture
//
//  Created by 陈旭 on 16/1/22.
//  Copyright © 2016年 陈旭. All rights reserved.
//

#import "XXLectureJoinViewController.h"

@interface XXLectureJoinViewController ()

@end

@implementation XXLectureJoinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 设置导航栏
    [self setupNav];
    
    // 设置讲座介绍图片
    [self setupPicView];
    
    // 设置专家简介部分
    [self setupExpertVc];
    
    // 设置在线交流部分
    [self setupQuestionVc];
}

- (void)setupNav{
    /* 导航栏标题 */
    self.title = @"公益讲堂";
}

- (void)setupPicView{
    
}

- (void)setupExpertVc{
    
}

- (void)setupQuestionVc{
    
}


@end
