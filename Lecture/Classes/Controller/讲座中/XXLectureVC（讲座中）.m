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
#import "CXShareTool.h"


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

@property (nonatomic, strong) XXXLectureModel *lectureDetail;// 讲座详情

@end

@implementation XXLectureVC
#pragma mark - 懒加载

#pragma mark - 生命周期

- (void)dealloc{
    [XXNotificationCenter removeObserver:self];
    
    [self.playerVc willMoveToParentViewController:nil];
    [[self.playerVc view] removeFromSuperview];
    [self.playerVc removeFromParentViewController];
    
    [self.expertVc willMoveToParentViewController:nil];
    [[self.expertVc view] removeFromSuperview];
    [self.expertVc removeFromParentViewController];
    
    [self.onlineVc willMoveToParentViewController:nil];
    [[self.onlineVc view] removeFromSuperview];
    [self.onlineVc removeFromParentViewController];
}
- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 创建XXPlayerVC
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
    [XXNotificationCenter addObserver:self selector:@selector(shareBtnClick) name:XXPlayerShareNotification object:nil];
    [XXNotificationCenter addObserver:self selector:@selector(showShareToWechatTimelineBtn) name:XXPlayerShareToTimeLineNotification object:nil];
    
//    [XXNotificationCenter addObserver:self selector:@selector(startPlaying) name:XXStartPlayingNotification object:nil];
//    [XXNotificationCenter addObserver:self selector:@selector(stopPlaying) name:XXStopPlayingNotification object:nil];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    if (self.isHiddenStatusBar) {
        [self showNavigationBarAndStatusBar];
    }
}


#pragma mark - 讲座的详情接口

- (void)setLecture:(XXXLectureModel *)lecture{
    _lecture = lecture;

    [self loadLectureDetail];// 传递数据给播放器
    
    _expertVc.lecture = lecture;// 传递数据给专家简介
    
}
- (void)loadLectureDetail
{
    [MBProgressHUD showHUDAddedTo:self.playerVc.view animated:YES];
    
    // 陈旭接口-讲座的详情接口
    NSString *url = [NSString stringWithFormat:@"lectures/%@", self.lecture.lectureId];
//    NSString *url = [NSString stringWithFormat:@"lectures/108"];//TODO: 定死id
    WS(weakSelf);
    [NetworkManager getWithApi:url params:nil success:^(id result) {
        _lectureDetail = [XXXLectureModel mj_objectWithKeyValues:result[@"data"][@"lecture"]];
        if(weakSelf.playerVc){
            weakSelf.playerVc.lectureDetail = _lectureDetail;
        }
        [MBProgressHUD hideHUDForView:weakSelf.playerVc.view animated:NO];
        
    } fail:^(NSError *error) {
        [MBProgressHUD hideHUDForView:weakSelf.playerVc.view animated:NO];
        [MBProgressHUD showError:@"讲座音频数据加载失败" toView:weakSelf.playerVc.view];
    }];
}
#pragma mark - 初始化

- (void)setupPlayerVc{
    
    XXPlayerVC *playerVc = [[XXPlayerVC alloc] init];
    [self addChildViewController:playerVc];
    [self.view addSubview:playerVc.view];
    [playerVc didMoveToParentViewController:self];
    
    self.playerVc = playerVc;

    _playerVc.view.x = 0;
    _playerVc.view.y = kXXStatusAndNavBarHeight;
    _playerVc.view.width = self.view.width;
    _playerVc.view.height = self.view.width * kXXPlayerPicViewHeightWidthRatio;
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
    [expertVc didMoveToParentViewController:self];
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

// 设置提问按钮（最底部）
- (void)setupPostQuestionBtn{
    
    XXButton *postQuestionBtn = [[XXButton alloc] init];
    [postQuestionBtn setTitle:@"提问" forState:UIControlStateNormal];
    UIImage *image =[UIImage imageNamed:@"before_question"];
    [postQuestionBtn setImage:image forState:UIControlStateNormal];
    [postQuestionBtn setBackgroundImage:[UIImage imageNamed:@"bottom_button_bg"] forState:UIControlStateNormal];
    postQuestionBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
    [postQuestionBtn addTarget:self action:@selector(postQuestion:) forControlEvents:UIControlEventTouchUpInside];
    postQuestionBtn.width = [UIScreen mainScreen].bounds.size.width;
    postQuestionBtn.height = kXXJoinButtonHeight;
    postQuestionBtn.x = 0;
    postQuestionBtn.y = self.view.height - postQuestionBtn.height;
    [self.view addSubview:postQuestionBtn];
    self.postQuestionBtn = postQuestionBtn;
    
    if (isExpert) {
        self.postQuestionBtn.height = 0;
    }
}

// 在线交流
- (void)setupOnlineVc{
    
    XXQuestionVC *onlineVc = [[XXQuestionVC alloc] init];
    onlineVc.view.x = 0;
    onlineVc.view.y = CGRectGetMaxY(self.onlineHeaderView.frame);
    onlineVc.view.width = self.view.width;
    onlineVc.view.height = self.view.height - onlineVc.view.y - self.postQuestionBtn.height;
    [self addChildViewController:onlineVc];
    [self.view addSubview:onlineVc.view];
    [onlineVc didMoveToParentViewController:self];
    self.onlineVc = onlineVc;
}

// 提问
- (void)postQuestion:(XXButton *)btn{
    
    XXQuestionCreateVC *vc = [[XXQuestionCreateVC alloc] initWithNibName:@"XXQuestionCreateVC" bundle:nil];
    //    vc.questionVC = self.questionVc;//TODO: 以后用通知或者代理来做
    vc.lecture = self.lecture;
    vc.view.frame = self.view.frame;
    XXNavigationController *nav = [[XXNavigationController alloc] initWithRootViewController:vc];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}


//#pragma mark - 点击关注按钮 XXExpertProfileHeaderViewDelegate
//- (void)expertProfileHeaderView:(XXExpertProfileHeaderView *)headerView didClickFollowBtn:(UIButton *)btn{
//    XXLog(@"follow");
//}

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
    WS(weakSelf);
    [UIView animateWithDuration:kXXHideAndShowPicViewDuration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        weakSelf.playerVc.view.y -= heightOne;
        weakSelf.expertVc.view.y -= heightOne;
        weakSelf.onlineHeaderView.y -= heightTwo;
        weakSelf.onlineVc.view.y -= heightTwo;
        weakSelf.onlineVc.view.height += heightTwo;
        
    } completion:^(BOOL finished) {
    }];
}

- (void)showPicView{

    // 需要下移的高度
    CGFloat heightOne = self.playerVc.playerPicView.height;
    CGFloat heightTwo = heightOne + kXXExpertHeaderViewHeight + kXXExpertTableViewHeight;
    WS(weakSelf);
    [UIView animateWithDuration:kXXHideAndShowPicViewDuration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        weakSelf.playerVc.view.y += heightOne;
        weakSelf.expertVc.view.y += heightOne;
        weakSelf.onlineHeaderView.y += heightTwo;
        weakSelf.onlineVc.view.y += heightTwo;
        weakSelf.onlineVc.view.height -= heightTwo;
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - 点击按钮切换横竖屏
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
    
    CGFloat sx = self.view.width / self.playerVc.view.height;
    CGFloat sy = self.view.height / self.playerVc.view.width;
    CGFloat tx = 0;
    CGFloat ty = self.view.centerY - self.playerVc.view.centerY;
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    transform = CGAffineTransformTranslate(transform, tx, ty);
    transform = CGAffineTransformScale(transform, sx , sy);
    transform = CGAffineTransformRotate(transform, M_PI_2);
    WS(weakSelf);
    [UIView animateWithDuration:duration animations:^{
        weakSelf.playerVc.view.transform = transform;
    }];
    
//    XXLog(@"_landscapeVc.view.width-%f, _landscapeVc.view.height-%f", _landscapeVc.view.width, _landscapeVc.view.height);
    // 隐藏导航栏和状态栏
    [self hideNavigationBarAndStatusBar];
}

- (void)hideLandscapeViewWithDuration:(NSTimeInterval)duration
{
    WS(weakSelf);
    [UIView animateWithDuration:duration animations:^{
        weakSelf.playerVc.view.transform = CGAffineTransformIdentity;
    }];
    // 显示导航栏和状态栏
    [self showNavigationBarAndStatusBar];
}

- (void)hideNavigationBarAndStatusBar
{
    self.hiddenStatusBar = YES;
    // 隐藏导航栏
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    // 隐藏状态栏
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
}

- (void)showNavigationBarAndStatusBar
{
    self.hiddenStatusBar = NO;
    // 显示导航栏
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    // 显示状态栏
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
}

#pragma mark - 隐藏导航栏和状态栏 适配iOS7

//- (BOOL)prefersStatusBarHidden{
//    // iOS7后,[[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
//    // 已经不起作用了
//    return _hiddenStatusBar;
//}
//
//- (void)showStatusBar
//{
//    _hiddenStatusBar = NO;
//    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
//        [self prefersStatusBarHidden];
//        [self setNeedsStatusBarAppearanceUpdate];
//    }
//}
//
//- (void)hideStatusBar
//{
//    _hiddenStatusBar = YES;
//    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
//        [self prefersStatusBarHidden];
//        [self setNeedsStatusBarAppearanceUpdate];
//    }
//}

//#pragma mark - 播放时隐藏导航栏和状态栏
//- (void)startPlaying{
//    // 隐藏导航栏
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
//    // 隐藏状态栏
//    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
//    
//    // 需要上移的高度
//    CGFloat height = kXXStatusAndNavBarHeight;
//    WS(weakSelf);
//    [UIView animateWithDuration:kXXHideAndShowPicViewDuration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//        weakSelf.playerVc.view.y -= height;
//        weakSelf.expertHeaderView.y -= height;
//        weakSelf.expertVc.view.y -= height;
//        weakSelf.onlineHeaderView.y -= height;
//        weakSelf.onlineVc.view.y -= height;
//        weakSelf.onlineVc.view.height += height;
//        
//    } completion:^(BOOL finished) {
//    }];
//}
//
//- (void)stopPlaying{
//    // 显示导航栏
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
//    // 显示状态栏
//    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
//    
//    // 需要下移的高度
//    CGFloat height = kXXStatusAndNavBarHeight;
//    WS(weakSelf);
//    [UIView animateWithDuration:kXXHideAndShowPicViewDuration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//        weakSelf.playerVc.view.y += height;
//        weakSelf.expertHeaderView.y += height;
//        weakSelf.expertVc.view.y += height;
//        weakSelf.onlineHeaderView.y += height;
//        weakSelf.onlineVc.view.y += height;
//        weakSelf.onlineVc.view.height -= height;
//    } completion:^(BOOL finished) {
//        
//    }];
//}

#pragma mark - share分享部分
- (void)shareBtnClick{
    // 设置点击返回的url和title
    NSString *url = [NSString stringWithFormat:@"http://lsh.kaimou.net/index.php/Home/Lecture/detail/id/%@?from=groupmessage&isappinstalled=1", self.lectureDetail.lectureId];
    NSString *title = self.lectureDetail.title;
    UIImage *image = [UIImage imageNamed:@"logo"];
    [CXShareTool shareInVc:self url:url title:title shareText:self.lectureDetail.desc shareImage:image];
}

- (void)showShareToWechatTimelineBtn{
    // 添加一个蒙版
    UIView *maskView = [UIView maskView];
    [XXTopWindow addSubview:maskView];
    // 添加分析提示页面的按钮到最顶层窗口
    UIButton *btn = [[UIButton alloc] init];
    [maskView addSubview:btn];
    btn.bounds = CGRectMake(0, 0, 250, 312);// 1:1.25
    btn.center = maskView.center;
    [btn setImage:[UIImage imageNamed:@"shareTip"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(shareToWechatTimeline:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)shareToWechatTimeline:(UIButton *)btn{
    
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:self.lectureDetail.desc image:[UIImage imageNamed:@"logo"] location:nil urlResource:nil presentedController:nil completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            NSLog(@"分享成功！");
            // 通知播放页面继续播放下一首
            [XXNotificationCenter postNotificationName:XXShareToWechatTimelineSuccessNotification object:nil];
            // 移除分享页面
            [btn.superview removeFromSuperview];
            // 保存已分享的讲座id
            UserDefaultsSaveBool(YES, self.lectureDetail.lectureId);
        }
    }];
}
  @end
