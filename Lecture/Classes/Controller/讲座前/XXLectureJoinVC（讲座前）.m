//
//  XXLectureJoinVC.m
//  Lecture
//
//  Created by 陈旭 on 16/1/22.
//  Copyright © 2016年 陈旭. All rights reserved.
//

#import "XXLectureJoinVC.h"
#import "XXCollectionCell.h"
#import "XXLecture.h"
#import "XXExpertProfileVC.h"
#import "XXQuestionVC.h"
#import "XXJoinLectureActionSheet.h"
#import <MJExtension.h>
#import "MBProgressHUD+CZ.h"
#import "XXQuestionHeaderView.h"
#import "XXExpertProfileHeaderView.h"
#import "XXQuestionCreateVC.h"
#import "XXNavigationController.h"
#import "CXTextView.h"

@interface XXLectureJoinVC ()<XXJoinLectureActionSheetDelegate, XXQuestionHeaderViewDelegate, XXExpertProfileHeaderViewDelegate>
@property (nonatomic, weak) UIImageView *picView;

@property (nonatomic, strong) NSArray *lectures;
@property (nonatomic, weak) XXExpertProfileHeaderView *expertHeaderView;
@property (nonatomic, weak) XXExpertProfileVC *expertVc;
@property (nonatomic, weak) XXQuestionHeaderView *questionHeaderView;
@property (nonatomic, weak) XXQuestionVC *questionVc;
@property (nonatomic, weak) XXButton *joinBtn;

@end

@implementation XXLectureJoinVC
#pragma mark - 懒加载

- (NSArray *)lectures
{
    if (!_lectures) {
        _lectures = [XXLecture mj_objectArrayWithFilename:@"Lectures.plist"];
    }
    return _lectures;
}

#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    
    // 设置导航栏
    [self setupNav];
    
    // 设置讲座介绍图片
    [self setupPicView];
    
    // 设置专家简介头部
    [self setupExpertHeaderView];
    
    // 设置专家简介
    [self setupExpertVc];
    
    // 设置精选提问头部
    [self setupQuestionHeaderView];
    
    // 设置精选提问部
    [self setupQuestionVc];
    
    // 设置报名活动按钮
    [self setupJoinBtn];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
}

#pragma mark - 只要点击虚拟键盘和编辑区域外的地方，就可以将键盘收起
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (![self.questionVc.textView isExclusiveTouch]) {
        [self.questionVc.textView removeFromSuperview];
    }
}

#pragma mark - 收起头部和展开头部

- (void)questionHeaderView:(XXQuestionHeaderView *)headerView didClickContractBtn:(UIButton *)btn{
    if (!btn.selected) {
        [self hidePicView];
    }else{
        [self showPicView];
    }
}

- (void)hidePicView{

    // 需要上移的高度
    CGFloat height = self.picView.height + kXXExpertHeaderViewHeight + kXXExpertTableViewHeight + kXXStatusAndNavBarHeight;
    
    // 隐藏导航栏
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    // 隐藏状态栏
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    
    [UIView animateWithDuration:kXXHideAndShowPicViewDuration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.questionHeaderView.y -= height;
        self.questionVc.view.y -= height;
        self.questionVc.view.height += height;
        
    } completion:^(BOOL finished) {
    }];
}

- (void)showPicView{
    // 需要下移的高度
    CGFloat height = self.picView.height + kXXExpertHeaderViewHeight + kXXExpertTableViewHeight + kXXStatusAndNavBarHeight;
    
    // 显示导航栏
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    // 显示状态栏
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
    
    [UIView animateWithDuration:kXXHideAndShowPicViewDuration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.questionHeaderView.y += height;
        self.questionVc.view.y += height;
        self.questionVc.view.height -= height;
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - 初始化

- (void)setupNav{
    /* 导航栏标题 */
    self.title = @"公益讲堂";
    
    // 创建分享按钮//TODO: 分享按钮换图片
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(clickShareLectureBtn) bgImageStr:@"before_nav_shar" bgHighImageStr:@"before_nav_shar"];;
}

- (void)setupPicView{
    
    UIImageView *picView = [[UIImageView alloc] init];
    picView.x = 0;
    picView.y = kXXStatusAndNavBarHeight;
    picView.width = self.view.width;
    picView.height = kXXPlayerPicViewHeightWidthRatio * picView.width;
    XXLecture *lecture = [self.lectures lastObject];
    picView.image = [UIImage imageNamed:lecture.profilePic];
    picView.userInteractionEnabled = YES;
    [self.view addSubview:picView];
    self.picView = picView;
}

// 专家简介头部
- (void)setupExpertHeaderView{
    
    XXExpertProfileHeaderView *expertHeaderView = [[[NSBundle mainBundle] loadNibNamed:@"XXExpertProfileHeaderView" owner:nil options:0]lastObject];
    expertHeaderView.x = 0;
    expertHeaderView.y = CGRectGetMaxY(self.picView.frame);
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

// 精选提问头部
- (void)setupQuestionHeaderView{
    XXQuestionHeaderView *questionHeaderView = [[[NSBundle mainBundle] loadNibNamed:@"XXQuestionHeaderView" owner:nil options:0]lastObject];
    questionHeaderView.x = 0;
    questionHeaderView.y = CGRectGetMaxY(self.expertVc.view.frame);
    questionHeaderView.height = kXXQuestionHeaderViewHeight;
    questionHeaderView.width = self.view.width;
    
    questionHeaderView.delegate = self; // 设置代理
    [self.view addSubview:questionHeaderView];
    self.questionHeaderView = questionHeaderView;
}

// 精选提问
- (void)setupQuestionVc{
    
    XXQuestionVC *questionVc = [[XXQuestionVC alloc] init];
    questionVc.view.x = 0;
    questionVc.view.y = CGRectGetMaxY(self.questionHeaderView.frame);
    questionVc.view.width = self.view.width;
    questionVc.view.height = self.view.height - questionVc.view.y - kXXJoinButtonHeight;
    [self addChildViewController:questionVc];
    [self.view addSubview:questionVc.view];
    self.questionVc = questionVc;
}


// 设置报名活动按钮
- (void)setupJoinBtn{
    
    XXButton *joinBtn = [[XXButton alloc] init];
    [joinBtn setTitle:@"我要报名" forState:UIControlStateNormal];
    [joinBtn setTitle:@"已报名" forState:UIControlStateDisabled];

    // 用纯色image作为背景可以实现按钮在disable状态下颜色变浅的效果
    [joinBtn setBackgroundImage:[UIImage createImageWithColor:XXColorGreen] forState:UIControlStateNormal];
    //    joinBtn.backgroundColor = XXColorGreen;
    
    [joinBtn addTarget:self action:@selector(joinBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    joinBtn.width = [UIScreen mainScreen].bounds.size.width;
    joinBtn.height = kXXJoinButtonHeight;
    joinBtn.x = 0;
    joinBtn.y = self.view.height - joinBtn.height;
    
    UIImage *joinBtnImage = [[UIImage imageNamed:@"before_enroll"] imageRenderingModeAlwaysOriginal];
    [joinBtn setImage:joinBtnImage forState:UIControlStateNormal];
    [joinBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];

    [self.view addSubview:joinBtn];
    self.joinBtn = joinBtn;
}


- (void)clickShareLectureBtn{
    //TODO: 点击分享按钮
    XXLog(@"clickShareLectureBtn");
}

#pragma mark - 点击报名
- (void)joinBtnClick:(XXButton *)btn{
    
    XXJoinLectureActionSheet *sheet = [[XXJoinLectureActionSheet alloc] init];
    sheet.delegate = self;
    sheet.lecture = [self.lectures lastObject];
    // 注意sheet要添加到窗口上，而非self.view上面，因为self.view会因为动画而改变frame，导致sheet的位置会变化
    [sheet showInView:XXKeyWindow];
}

#pragma mark - XXJoinLectureActionSheetDelegate 点击确认报名后
- (void)joinLectureActionSheet:(XXJoinLectureActionSheet *)sheet didClickDoneButton:(UIButton *)btn{
    
    //TODO: 点击确认报名后，网络请求，扣除积分等，报名失败的情况
    // 如果报名成功
    [MBProgressHUD showHUDAddedTo:XXKeyWindow animated:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:XXKeyWindow animated:NO];
        [MBProgressHUD showSuccess:@"报名成功！" toView:XXKeyWindow];
        self.joinBtn.enabled = NO;
    });
}

#pragma mark - 点击关注按钮 XXExpertProfileHeaderViewDelegate
- (void)expertProfileHeaderView:(XXExpertProfileHeaderView *)headerView didClickFollowBtn:(UIButton *)btn{
    XXLog(@"follow");//TODO:点击关注按钮
}

#pragma mark - 点击提问按钮跳到提问界面 XXQuestionHeaderViewDelegate
- (void)questionHeaderView:(XXQuestionHeaderView *)headerView didClickPostQuestionBtn:(UIButton *)btn
{
    XXQuestionCreateVC *vc = [[XXQuestionCreateVC alloc] initWithNibName:@"XXQuestionCreateVC" bundle:nil];
    vc.questionVC = self.questionVc;//TODO: 以后用通知或者代理来做
    vc.view.frame = self.view.frame;
    XXNavigationController *nav = [[XXNavigationController alloc] initWithRootViewController:vc];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}

- (void)dealloc{
    XXTestLog;
}

@end
