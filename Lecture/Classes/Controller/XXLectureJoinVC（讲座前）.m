//
//  XXLectureJoinVC.m
//  Lecture
//
//  Created by 陈旭 on 16/1/22.
//  Copyright © 2016年 陈旭. All rights reserved.
//

#import "XXLectureJoinVC.h"
#import "XXCollectionCell.h"
#import "XXCollectionView.h"
#import "XXLecture.h"
#import "XXExpertProfileVC.h"
#import "XXQuestionVC.h"
#import "XXJoinLectureActionSheet.h"
#import <MJExtension.h>
#import "MBProgressHUD+CZ.h"

@interface XXLectureJoinVC ()<XXJoinLectureActionSheetDelegate>
@property (nonatomic, weak) UIImageView *picView;

@property (nonatomic, strong) NSArray *lectures;
@property (nonatomic, weak) XXExpertProfileVC *expertVc;
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

#pragma mark - 收到展开和收起头部通知后的处理

- (void)hidePicView{

    // 需要上移的高度
    CGFloat height = self.picView.height + XXExpertProfileViewHeight;
    
    [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.view.y -= height;
        // 在上移控制器的view的时候，同步下移报名按钮，这样就可以保证报名按钮一直在最下方
        self.joinBtn.y += height;
        self.view.height += height;// 必须调整这个，否则导致tableView的下面一部分超出self.view，没法交互
        
    } completion:^(BOOL finished) {
        NSLog(@"%f", self.joinBtn.y);
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
    XXLecture *lecture = [self.lectures lastObject];
    picView.image = [UIImage imageNamed:lecture.profilePic];
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
    
    XXExpertProfileVC *expertVc = [[XXExpertProfileVC alloc] init];
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
    
    XXQuestionVC *questionVc = [[XXQuestionVC alloc] init];
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
    [joinBtn setTitle:@"已报名" forState:UIControlStateDisabled];

    // 用纯色image作为背景可以实现按钮在disable状态下颜色变浅的效果
    [joinBtn setBackgroundImage:[UIImage createImageWithColor:XXColorGreen] forState:UIControlStateNormal];
    //    joinBtn.backgroundColor = XXColorGreen;
    
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

#pragma mark - 点击报名
- (void)joinBtnClick:(XXButton *)btn{
    
    XXJoinLectureActionSheet *sheet = [[XXJoinLectureActionSheet alloc] init];
    sheet.delegate = self;
    sheet.lecture = [self.lectures lastObject];
    // 注意sheet要添加到窗口上，而非self.view上面，因为self.view会因为动画而改变frame，导致sheet的位置会变化
    [sheet showInView:XXWindow];
}

#pragma mark - XXJoinLectureActionSheetDelegate 点击确认报名后
- (void)joinLectureActionSheet:(XXJoinLectureActionSheet *)sheet didClickDoneButton:(UIButton *)btn{
    
    //TODO: 点击确认报名后，网络请求，扣除积分等，报名失败的情况
    // 如果报名成功
    [MBProgressHUD showHUDAddedTo:XXWindow animated:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:XXWindow animated:NO];
        [MBProgressHUD showSuccess:@"报名成功！" toView:XXWindow];
        self.joinBtn.enabled = NO;
    });
    
    
}

@end
