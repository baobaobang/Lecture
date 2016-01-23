//
//  XXLectureJoinViewController.m
//  Lecture
//
//  Created by 陈旭 on 16/1/22.
//  Copyright © 2016年 陈旭. All rights reserved.
//

#import "XXLectureJoinViewController.h"
#import "XXCollectionCell.h"
#import "XXCollectionView.h"
#import "XXLecture.h"
#import "XXExpertProfileViewController.h"
#import "XXQuestionViewController.h"

@interface XXLectureJoinViewController ()
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
    [XXNotificationCenter addObserver:self selector:@selector(hidePicView) name:XXPlayerPicViewWillHide object:nil];
    [XXNotificationCenter addObserver:self selector:@selector(showPicView) name:XXPlayerPicViewWillShow object:nil];
}

- (void)dealloc{
    [XXNotificationCenter removeObserver:self];
}

#pragma mark - 收到通知后的处理

- (void)hidePicView{

    // 需要上移的高度
    CGFloat height = self.picView.height + XXExpertProfileViewHeight;
    
    [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.view.y -= height;
        // 在上移控制器的view的时候，同步下移报名按钮，这样就可以保证报名按钮一直在最下方
        self.joinBtn.y += height;
        self.view.height += height;// 必须调整这个，否则导致tableView的下面一部分超出self.view，没法交互
        
    } completion:^(BOOL finished) {
    }];
    
}

- (void)showPicView{
    
    // 需要下移的高度
    CGFloat height = self.picView.height + XXExpertProfileViewHeight;
    
    [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.view.y += height;
        self.joinBtn.y -= height;
        self.view.height -= height;
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
    picView.userInteractionEnabled = YES;
    [self.view addSubview:picView];
    self.picView = picView;
    
    // 创建分享按钮
    UIButton *shareBtn = [[UIButton alloc] init];
    [shareBtn setBackgroundImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
    shareBtn.width = 25;
    shareBtn.height = shareBtn.width;
    shareBtn.x = picView.width - shareBtn.width - 10;
    shareBtn.y = 10;
    [shareBtn addTarget:self action:@selector(clickShareLectureBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.picView addSubview:shareBtn];
}

- (void)setupExpertVc{
    
    XXExpertProfileViewController *expertVc = [[XXExpertProfileViewController alloc] init];
    expertVc.view.x = 0;
    expertVc.view.y = CGRectGetMaxY(self.picView.frame);
    expertVc.view.width = self.view.width;
    expertVc.view.height = XXExpertProfileViewHeight;
//    expertVc.tableView.bounces = NO;
    [self addChildViewController:expertVc];
    [self.view addSubview:expertVc.view];
    self.expertVc = expertVc;
}

- (void)setupQuestionVc{
    
    XXQuestionViewController *questionVc = [[XXQuestionViewController alloc] init];
    questionVc.view.x = 0;
    questionVc.view.y = CGRectGetMaxY(self.expertVc.view.frame);
    questionVc.view.width = self.view.width;
    questionVc.view.height = self.view.height - questionVc.view.y - XXJoinButtonHeight;
//    questionVc.tableView.bounces = NO;
    [self addChildViewController:questionVc];
    [self.view addSubview:questionVc.view];
    self.questionVc = questionVc;
}


// 设置报名活动按钮
- (void)setupJoinBtn{
    
    XXButton *joinBtn = [[XXButton alloc] init];
    [joinBtn setTitle:@"我要报名" forState:UIControlStateNormal];
    joinBtn.backgroundColor = XXQuestionTintColor;
    [joinBtn addTarget:self action:@selector(joinBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    joinBtn.width = [UIScreen mainScreen].bounds.size.width;
    joinBtn.height = XXJoinButtonHeight;
    joinBtn.x = 0;
    joinBtn.y = self.view.height - joinBtn.height;
    
    UIImage *joinBtnImage = [[[UIImage imageNamed:@"enroll"] imageScaleToSize:CGSizeMake(20, 20)] imageRenderingModeAlwaysOriginal];
    [joinBtn setImage:joinBtnImage forState:UIControlStateNormal];
    [joinBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    
    [self.view addSubview:joinBtn];
    [self.view bringSubviewToFront:joinBtn]; // 让joinBtn在最上层
    self.joinBtn = joinBtn;
}


- (void)clickShareLectureBtn{
    
}

- (void)joinBtnClick:(XXButton *)btn{
    
}

@end
