//
//  XXLectureJoinVC.m
//  Lecture
//
//  Created by 陈旭 on 16/1/22.
//  Copyright © 2016年 陈旭. All rights reserved.
//

#import "XXLectureJoinVC.h"
#import "XXCollectionCell.h"
#import "XXXLectureModel.h"
#import "XXExpertProfileVC.h"
#import "XXQuestionVC.h"
#import "XXJoinLectureActionSheet.h"
#import "MJExtension.h"
#import "MBProgressHUD+CZ.h"
#import "XXQuestionHeaderView.h"
#import "XXExpertProfileHeaderView.h"
#import "XXQuestionCreateVC.h"
#import "XXNavigationController.h"
#import "CXTextView.h"
#import <UMSocial.h>
#import "XXXLoginVC.h"

@interface XXLectureJoinVC ()<XXJoinLectureActionSheetDelegate, XXQuestionHeaderViewDelegate, XXExpertProfileHeaderViewDelegate>
@property (nonatomic, weak) UIImageView *picView;
@property (nonatomic, weak) XXExpertProfileHeaderView *expertHeaderView;
@property (nonatomic, weak) XXExpertProfileVC *expertVc;
@property (nonatomic, weak) XXQuestionHeaderView *questionHeaderView;
@property (nonatomic, weak) XXQuestionVC *questionVc;
@property (nonatomic, weak) XXButton *joinBtn;

@end

@implementation XXLectureJoinVC
#pragma mark - 懒加载

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
    
    // 设置精选提问部分
    [self setupQuestionVc];
    
    // 设置报名活动按钮
    [self setupJoinBtn];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
}


- (void)dealloc{
    [self.expertVc willMoveToParentViewController:nil];
    [[self.expertVc view] removeFromSuperview];
    [self.expertVc removeFromParentViewController];

    [self.questionVc willMoveToParentViewController:nil];
    [[self.questionVc view] removeFromSuperview];
    [self.questionVc removeFromParentViewController];
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
    CGFloat height = self.picView.height + kXXExpertHeaderViewHeight + kXXExpertTableViewHeight;
    
//    // 隐藏导航栏
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
//    // 隐藏状态栏
//    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    
    WS(weakSelf);
    [UIView animateWithDuration:kXXHideAndShowPicViewDuration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        weakSelf.questionHeaderView.y -= height;
        weakSelf.questionVc.view.y -= height;
        weakSelf.questionVc.view.height += height;
        
    } completion:^(BOOL finished) {
    }];
}

- (void)showPicView{
    // 需要下移的高度
    CGFloat height = self.picView.height + kXXExpertHeaderViewHeight + kXXExpertTableViewHeight;
    
//    // 显示导航栏
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
//    // 显示状态栏
//    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
    
    WS(weakSelf);
    [UIView animateWithDuration:kXXHideAndShowPicViewDuration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        weakSelf.questionHeaderView.y += height;
        weakSelf.questionVc.view.y += height;
        weakSelf.questionVc.view.height -= height;
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - 初始化

- (void)setupNav{
    /* 导航栏标题 */
    self.title = @"公益讲堂";
    
    /* 设置导航栏分享按钮 */
    UIImage *rightImage = [UIImage imageNamed:@"before_nav_share"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:rightImage style:UIBarButtonItemStyleDone target:self action:@selector(clickShareLectureBtn)];
}

- (void)setupPicView{
    
    UIImageView *picView = [[UIImageView alloc] init];
    picView.x = 0;
    picView.y = kXXStatusAndNavBarHeight;
    picView.width = self.view.width;
    picView.height = kXXPlayerPicViewHeightWidthRatio * picView.width;
    [picView sd_setImageWithURL:[NSURL URLWithString:self.lecture.cover]  placeholderImage:[UIImage imageNamed:@"placeholder_lecture_cover"]];//占位图
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
    [expertVc didMoveToParentViewController:self];
    self.expertVc = expertVc;
    
    expertVc.lecture = self.lecture;// 传递数据
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
    questionVc.lecture = self.lecture;
    questionVc.view.x = 0;
    questionVc.view.y = CGRectGetMaxY(self.questionHeaderView.frame);
    questionVc.view.width = self.view.width;
    questionVc.view.height = self.view.height - questionVc.view.y - kXXJoinButtonHeight;
    [self addChildViewController:questionVc];
    [self.view addSubview:questionVc.view];
    [questionVc didMoveToParentViewController:self];
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


#pragma mark - 分享页面
- (void)clickShareLectureBtn{
    
    // 设置点击返回的url和title
    NSString *url = [NSString stringWithFormat:@"http://lsh.kaimou.net/index.php/Home/Lecture/detail/id/%@?from=groupmessage&isappinstalled=1", self.lecture.lectureId];
    NSString *title = self.lecture.title;
    [UMSocialData defaultData].extConfig.wechatSessionData.url = url;
    [UMSocialData defaultData].extConfig.wechatSessionData.title = title;
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = url;
    [UMSocialData defaultData].extConfig.wechatTimelineData.title = title;
    [UMSocialData defaultData].extConfig.qqData.url = url;
    [UMSocialData defaultData].extConfig.qqData.title = title;
    [UMSocialData defaultData].extConfig.sinaData.urlResource.url = url;
    [UMSocialData defaultData].extConfig.sinaData.snsName = @"医讲堂";
    
    // 跳出分享页面
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:UMKey
                                      shareText:self.lecture.desc
                                     shareImage:[UIImage imageNamed:@"logo"]
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQQ,UMShareToSina,nil]
                                       delegate:nil];
}

#pragma mark - 点击报名
- (void)joinBtnClick:(XXButton *)btn{
    
    // 判断是否登录
    if (ACCESS_TOKEN) { // 如果已经登录
        XXJoinLectureActionSheet *sheet = [[XXJoinLectureActionSheet alloc] init];
        sheet.delegate = self;
        sheet.lecture = self.lecture;
        // 注意sheet要添加到窗口上，而非self.view上面，因为self.view会因为动画而改变frame，导致sheet的位置会变化
        [sheet showInView:XXKeyWindow];
    }else{ // 如果未登录
        XXXLoginVC *vc = [[XXXLoginVC alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }

}

#pragma mark - XXJoinLectureActionSheetDelegate 点击确认报名后
- (void)joinLectureActionSheet:(XXJoinLectureActionSheet *)sheet didClickDoneButton:(UIButton *)btn{
    [MBProgressHUD showHUDAddedTo:XXKeyWindow animated:YES];
    
    // 陈旭接口-报名接口
    WS(weakSelf);
    NSString *url = [NSString stringWithFormat:@"lectures/%@/enroll", self.lecture.lectureId];
    [NetworkManager postWithApi:url params:nil success:^(id result) {
        if ([result[@"ret"] intValue] == 0) {
            [MBProgressHUD hideHUDForView:XXKeyWindow animated:NO];
            [MBProgressHUD showSuccess:@"报名成功！" toView:XXKeyWindow];
            weakSelf.joinBtn.enabled = NO;
        }else{
            [MBProgressHUD hideHUDForView:XXKeyWindow animated:NO];
            [MBProgressHUD showSuccess:@"人数已满，报名失败！" toView:XXKeyWindow];
        }
    } fail:^(NSError *error) {
        [MBProgressHUD hideHUDForView:XXKeyWindow animated:NO];
        [MBProgressHUD showError:@"报名失败" toView:weakSelf.view];
    }];

}

#pragma mark - 点击关注按钮 XXExpertProfileHeaderViewDelegate
- (void)expertProfileHeaderView:(XXExpertProfileHeaderView *)headerView didClickFollowBtn:(UIButton *)btn{
    XXLog(@"follow");//TODO:点击关注按钮
}

#pragma mark - 点击提问按钮跳到提问界面 XXQuestionHeaderViewDelegate
- (void)questionHeaderView:(XXQuestionHeaderView *)headerView didClickPostQuestionBtn:(UIButton *)btn
{
    // 判断是否登录
    if (ACCESS_TOKEN) { // 如果已经登录
        XXQuestionCreateVC *vc = [[XXQuestionCreateVC alloc] initWithNibName:@"XXQuestionCreateVC" bundle:nil];
        vc.lecture = self.lecture;
        vc.questionVC = self.questionVc;//TODO: 以后用通知或者代理来做
        vc.view.frame = self.view.frame;
        XXNavigationController *nav = [[XXNavigationController alloc] initWithRootViewController:vc];
        [self.navigationController presentViewController:nav animated:YES completion:nil];
    }else{ // 如果未登录
        XXXLoginVC *vc = [[XXXLoginVC alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}


@end
