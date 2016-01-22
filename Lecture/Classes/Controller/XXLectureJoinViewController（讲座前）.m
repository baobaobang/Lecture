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
#import "XXExpertProfileViewController.h"
#import "XXQuestionViewController.h"

@interface XXLectureJoinViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, weak) UIImageView *picView;

@property (nonatomic, strong) XXLecture *lecture;
@property (nonatomic, weak) XXExpertProfileViewController *expertVc;
@property (nonatomic, weak) XXQuestionViewController *questionVc;
@property (nonatomic, weak) XXButton *joinBtn;
@end

@implementation XXLectureJoinViewController
#pragma mark - 懒加载

- (XXLecture *)lecture
{
    if (!_lecture) {
        _lecture = [[XXLecture alloc] init];
        _lecture.profilePic = @"讲座介绍图";
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
    
    // 设置精选提问部分
    [self setupQuestionVc];
    
    // 设置joinBtn，报名活动按钮
    [self setupJoinBtn];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // 注册观察者，接收XXExpertProfileHeaderView发出的通知
    [HWNotificationCenter addObserver:self selector:@selector(hidePicView) name:XXPlayerPicViewWillHide object:nil];
    [HWNotificationCenter addObserver:self selector:@selector(showPicView) name:XXPlayerPicViewWillShow object:nil];
}

- (void)dealloc{
    [HWNotificationCenter removeObserver:self];
}

#pragma mark - 收到通知后的处理

- (void)hidePicView{
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.view.y -= self.picView.height;
        // 在上移控制器的view的时候，同步下移报名按钮，这样就可以保证报名按钮一直在最下方
        self.joinBtn.y += self.picView.height;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)showPicView{
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.view.y += self.picView.height;
        self.joinBtn.y -= self.picView.height;
    } completion:^(BOOL finished) {
        
    }];
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
    
    XXExpertProfileViewController *expertVc = [[XXExpertProfileViewController alloc] init];
    expertVc.view.x = 0;
    expertVc.view.y = CGRectGetMaxY(self.picView.frame);
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
- (void)setupJoinBtn{
    
    XXButton *joinBtn = [[XXButton alloc] init];
    [joinBtn setTitle:@"我要报名" forState:UIControlStateNormal];
    joinBtn.backgroundColor = HWQuestionTintColor;
    [joinBtn addTarget:self action:@selector(joinBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    joinBtn.width = [UIScreen mainScreen].bounds.size.width;
    joinBtn.height = XXJoinButtonHeight;
    joinBtn.x = 0;
    joinBtn.y = self.view.height - joinBtn.height;
    [self.view addSubview:joinBtn];
    self.joinBtn = joinBtn;
}


- (void)joinBtnClick:(XXButton *)btn{
    
}

@end
