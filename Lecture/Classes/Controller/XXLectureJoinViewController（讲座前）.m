//
//  XXLectureJoinViewController.m
//  Lecture
//
//  Created by 陈旭 on 16/1/22.
//  Copyright © 2016年 陈旭. All rights reserved.
//

#import "XXLectureJoinViewController.h"
#import "HMCollectionCell.h"
#import "XXCollectionView.h"
#import "XXLecture.h"

@interface XXLectureJoinViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, weak) UIImageView *picView;

@property (nonatomic, strong) XXLecture *lecture;
@end

@implementation XXLectureJoinViewController
#pragma mark - 懒加载

- (XXLecture *)lecture
{
    if (!_lecture) {
        _lecture = [[XXLecture alloc] init];
        _lecture.profilePic = @"上呼吸道的概念";
    }
    return _lecture;
}


#pragma mark - 生命周期
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

#pragma mark - 初始化

- (void)setupNav{
    /* 导航栏标题 */
    self.title = @"公益讲堂";
}

- (void)setupPicView{
    
    UIImageView *picView = [[UIImageView alloc] init];
    picView.x = 0;
    picView.y = XXStatusAndNavBarHeight;
    picView.width = self.view.width;
    picView.height = XXPlayerPicViewHeightWidthRatio * picView.width;
    picView.image = [UIImage imageNamed:self.lecture.profilePic];
    [self.view addSubview:picView];
    self.picView = picView;
}

- (void)setupExpertVc{
    
}

- (void)setupQuestionVc{
    
}



@end
