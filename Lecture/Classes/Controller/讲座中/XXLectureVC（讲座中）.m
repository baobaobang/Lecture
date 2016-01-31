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

@property (nonatomic, assign, getter=isLandscape) BOOL landscape;
@property (nonatomic, assign, getter=isHiddenStatusBar) BOOL hiddenStatusBar;

@end

@implementation XXLectureVC
#pragma mark - 懒加载

#pragma mark - 生命周期
- (void)viewDidLoad{
    
    self.view.backgroundColor = [UIColor whiteColor];
    
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
    [self addChildViewController:playerVc];
    [self.view addSubview:playerVc.view];
    self.playerVc = playerVc;

    _playerVc.view.x = 0;
    _playerVc.view.y = kXXStatusAndNavBarHeight;
    _playerVc.view.width = self.view.width;
    _playerVc.view.height = self.view.width * 0.6;
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

// 点击按钮切换横竖屏
- (void)landscapeBtnClick{
    
    if (!_landscape) { // 如果现在是竖屏就转为横屏播放
        [self showLandscapeViewWithDuration:kXXPlayerVCChageToLandscapeDuration];
    }else{
       [self hideLandscapeViewWithDuration:kXXPlayerVCChageToLandscapeDuration];
    }
    _landscape = !_landscape;
}

- (void)showLandscapeViewWithDuration:(NSTimeInterval)duration
{
    [self.view bringSubviewToFront:self.playerVc.view];
    // 旋转和缩放动画
    CGFloat sx = self.view.height / self.playerVc.view.width;
    CGFloat sy = self.view.width / self.playerVc.view.height;
    CGFloat tx = 0;
    CGFloat ty = self.view.centerY - self.playerVc.view.centerY;
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    transform = CGAffineTransformTranslate(transform, tx, ty);
    transform = CGAffineTransformScale(transform, sx, sy);
    transform = CGAffineTransformRotate(transform, M_PI_2);
    [UIView animateWithDuration:duration animations:^{
        self.playerVc.view.transform = transform;
    }];
    
    XXLog(@"%@", NSStringFromCGRect(self.playerVc.view.frame)) ;
    
//    XXLog(@"_landscapeVc.view.width-%f, _landscapeVc.view.height-%f", _landscapeVc.view.width, _landscapeVc.view.height);

    // 隐藏导航栏
    [self.navigationController setNavigationBarHidden:YES];
    // 隐藏状态栏
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    //    [self hideStatusBar];
}

- (void)hideLandscapeViewWithDuration:(NSTimeInterval)duration
{
    
    [UIView animateWithDuration:duration animations:^{
        self.playerVc.view.transform = CGAffineTransformIdentity;
    }];

    // 显示导航栏
    [self.navigationController setNavigationBarHidden:NO];
    // 显示状态栏
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

#pragma mark - 隐藏导航栏和状态栏 适配iOS7

- (BOOL)prefersStatusBarHidden{
    // iOS7后,[[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    // 已经不起作用了
    return _hiddenStatusBar;
}

- (void)showStatusBar
{
    _hiddenStatusBar = NO;
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        [self prefersStatusBarHidden];
        [self setNeedsStatusBarAppearanceUpdate];
    }
}

- (void)hideStatusBar
{
    _hiddenStatusBar = YES;
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        [self prefersStatusBarHidden];
        [self setNeedsStatusBarAppearanceUpdate];
    }
}


@end
