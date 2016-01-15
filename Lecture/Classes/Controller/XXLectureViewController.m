//
//  XXLectureViewController.m
//  Lecture
//
//  Created by 陈旭 on 16/1/7.
//  Copyright © 2016年 陈旭. All rights reserved.
//

#import "XXLectureViewController.h"
#import "XXPlayerView.h"
#import "HWNavigationController.h"
#import "XXExpertProfileCell.h"
#import "XXExpertProfileHeaderView.h"
#import "XXQuestionCell.h"
#import "XXQuestionHeaderView.h"
#import "XXQuestionToolbar.h"
#import "MJExtension.h"

#define XXNavigationTitleFont 18
#define XXExpertProfileCellHeight 80
#define XXQuestionCellHeight 100

#define XXExpertProfileText @"治疗顽固性咳嗽、哮喘、间质性肺炎、反复呼吸道感染、过敏性鼻炎、慢支、肺部肿瘤等呼吸系统疾病；中西医结合治疗儿童各类呼吸系统疾病"

typedef enum{
    XXExpertProfileSection, // 专家简介
    XXQuestionSection // 精选提问
}XXTableViewSection;

@interface XXLectureViewController ()<UITableViewDataSource, UITableViewDelegate, XXQuestionToolbarDelegate>
/**  */
@property (weak, nonatomic) IBOutlet XXPlayerView *playerView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *joinBtn;
/** 最近打开cell的indexPath */
@property (nonatomic, strong) NSIndexPath *currentOpenIndexPath;
/** 是否有cell处于打开状态，同一时间只能有一个cell处于打开状态 */
@property (nonatomic, assign) BOOL isOpenCell;

@property (nonatomic, strong) NSArray *questionContents;

@property (nonatomic, strong) NSArray *questions;
@end

@implementation XXLectureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置导航栏内容
    [self setupNav];
    
    // 初始化XXPlayerView
    XXPlayerView *playerView = [XXPlayerView playerView];
    [self.playerView addSubview:playerView];
    
    // 设置报名活动按钮颜色
    self.joinBtn.backgroundColor = HWQuestionTintColor;
    
    //
    self.currentOpenIndexPath = [NSIndexPath indexPathForItem:-1 inSection:-1];
    
}

- (NSArray *)questions
{
    if (!_questions) {
        _questions = [XXQuestion objectArrayWithFilename:@"Questions.plist"];
    }
    return _questions;
}


- (NSArray *)questionContents
{
    if (!_questionContents) {
        _questionContents = @[@"张医生辛苦，听好多妈妈说宝宝接种了流感疫苗后感觉更容易感冒了，社区让打流感疫苗我吓的一直没去，是不是真的如此呢，前天带宝宝出了门回来夜里就发烧了", @"孩子在家不咳嗽～出门就咳嗽怎么办", @"一岁孩子，感冒后总是咳嗽不好，好了两个星期了，但是一直咳嗽，不严重，就是好像嗓子有痰似的，尤其晚上睡觉醒后比较严重，白天咳嗽还不是很厉害", @"这几天新闻说上海流感比较多，H1N1,希望老师多讲讲"];
    }
    return _questionContents;
}


/**
 *  设置导航栏内容
 */
- (void)setupNav
{
    /* 设置导航栏上面的内容 */
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(leftItemClick) image:@"navigationbar_friendsearch" highImage:@"navigationbar_friendsearch_highlighted"];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(rightItemClick) image:@"navigationbar_pop" highImage:@"navigationbar_pop_highlighted"];
    
    /* 导航栏标题 */
    self.title = @"公益讲堂";
    NSMutableDictionary *attr = [NSMutableDictionary dictionary];
    attr[NSFontAttributeName] = [UIFont systemFontOfSize:XXNavigationTitleFont];
    attr[NSForegroundColorAttributeName] = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:attr];
    
    /* 设置导航栏的背景颜色 */
    self.navigationController.navigationBar.barTintColor = HWTintColor;
}

- (void)leftItemClick
{
    NSLog(@"leftItemClick");
}

- (void)rightItemClick
{
    NSLog(@"rightItemClick");
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == XXExpertProfileSection) {
        return 1;
    }else{
        return 4;
    }
}

// cell创建和数据
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == XXExpertProfileSection) {
        XXExpertProfileCell *expertCell = [XXExpertProfileCell expertProfileCellInTableView:tableView];
        // 设计专家头像为原型
        CGFloat borderWidth = expertCell.imageView.width;
        UIImage *expertIcon = [UIImage circleImageWithName:@"expert_2" borderWidth:borderWidth borderColor:[UIColor clearColor]];
        [expertCell.expertIconBtn setBackgroundImage:expertIcon forState:UIControlStateNormal];

        return expertCell;
    }else{
        XXQuestionCell *questionCell = [XXQuestionCell QuestionCellInTableView:tableView];
        
        questionCell.toolBar.delegate = self;
        
        // 屏蔽按钮的显示与隐藏
        if ([indexPath compare:self.currentOpenIndexPath] == NSOrderedSame && self.isOpenCell == YES) {
            // 展开cell，显示屏蔽按钮
            questionCell.shieldBtn.hidden = NO;
        }else{
            // 折叠cell，隐藏屏蔽按钮
            questionCell.shieldBtn.hidden = YES;
        }
        
        
//        @property (nonatomic, weak) UIButton *shareBtn;
//        @property (nonatomic, weak) UIButton *replyBtn;
//        @property (nonatomic, weak) UIButton *attitudeBtn;
        // 假数据
        XXQuestionToolbar *toolbar = questionCell.toolBar;
        toolbar.question = self.questions[indexPath.row];
        
        switch (indexPath.row) {
            case 0:
                questionCell.userNameLabel.text = @"李灵黛";
                questionCell.userLevelView.image = [UIImage imageNamed:@"user_vip_1"];
                [questionCell.userIconBtn setBackgroundImage:[UIImage imageNamed:@"userIcon_1"] forState:UIControlStateNormal];
                questionCell.questionContentLabel.text = @"张医生辛苦，听好多妈妈说宝宝接种了流感疫苗后感觉更容易感冒了，社区让打流感疫苗我吓的一直没去，是不是真的如此呢，前天带宝宝出了门回来夜里就发烧了";
                
                break;
            case 1:
                
                questionCell.userNameLabel.text = @"冷文卿";
                questionCell.userLevelView.image = [UIImage imageNamed:@"user_vip_2"];
                [questionCell.userIconBtn setBackgroundImage:[UIImage imageNamed:@"userIcon_2"] forState:UIControlStateNormal];
                questionCell.questionContentLabel.text = @"孩子在家不咳嗽～出门就咳嗽怎么办";
                break;
            case 2:
                
                questionCell.userNameLabel.text = @"李念";
                questionCell.userLevelView.image = [UIImage imageNamed:@"user_vip_3"];
                [questionCell.userIconBtn setBackgroundImage:[UIImage imageNamed:@"userIcon_3"] forState:UIControlStateNormal];
                questionCell.questionContentLabel.text = @"一岁孩子，感冒后总是咳嗽不好，好了两个星期了，但是一直咳嗽，不严重，就是好像嗓子有痰似的，尤其晚上睡觉醒后比较严重，白天咳嗽还不是很厉害";
                break;
            case 3:
                
                questionCell.userNameLabel.text = @"魏天霞";
                questionCell.userLevelView.image = [UIImage imageNamed:@"user_vip_1"];
                [questionCell.userIconBtn setBackgroundImage:[UIImage imageNamed:@"userIcon_4"] forState:UIControlStateNormal];
                questionCell.questionContentLabel.text = @"这几天新闻说上海流感比较多，H1N1,希望老师多讲讲";
                break;
                
            default:
                break;
        }
        
        return questionCell;
    }
}

#pragma mark - 自定义的headerView
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == XXExpertProfileSection) {
        return [XXExpertProfileHeaderView headerView];
    }else{
        return [XXQuestionHeaderView headerView];
    }
}

#pragma mark - cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
  
    if (indexPath.section == XXExpertProfileSection) {// 专家简介部分
        XXExpertProfileCell *expertCell = [XXExpertProfileCell expertProfileCellInTableView:tableView];
        if ([indexPath compare:self.currentOpenIndexPath] == NSOrderedSame && self.isOpenCell == YES) {
            // 展开cell，根据内容自动调整高度
            [expertCell cellAutoLayoutHeight:XXExpertProfileText];
            CGSize size = [expertCell.contentView systemLayoutSizeFittingSize:UILayoutFittingExpandedSize];
            return  MAX((size.height + 1), XXExpertProfileCellHeight);
            
        }else{
            // 折叠cell，默认高度
            return XXExpertProfileCellHeight;
        }
        
    }else{// 精选提问部分
        XXQuestionCell *questionCell = [XXQuestionCell QuestionCellInTableView:tableView];
        if ([indexPath compare:self.currentOpenIndexPath] == NSOrderedSame && self.isOpenCell == YES) {
            // 展开cell，根据内容自动调整高度
            [questionCell cellAutoLayoutHeight:self.questionContents[indexPath.row]];
            CGSize size = [questionCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
            return MAX((size.height + 1), XXQuestionCellHeight);
        }else{
            // 折叠cell，默认高度
            return XXQuestionCellHeight;
        }
    }
}

#pragma mark - 估算的cell的高度
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == XXExpertProfileSection) {
        return XXExpertProfileCellHeight;
    }else{
        return XXQuestionCellHeight;
    }
}

#pragma mark - headerView的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}

#pragma mark - 点击cell后的反应
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // 判断是否要展开cell
    if ([indexPath compare:self.currentOpenIndexPath] == NSOrderedSame)
    {
        self.isOpenCell = !self.isOpenCell;
    }else{
        self.isOpenCell = YES;
    }
    self.currentOpenIndexPath = indexPath;


//    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [tableView reloadData];
}

#pragma mark - XXQuestionToolbar的按钮被点击了
- (void)questionToolbar:(XXQuestionToolbar *)toolbar didClickBtnType:(XXQuestionToolbarButtonType)type{
    // 刷新toolbar对应的cell
    XXQuestionCell *cell = (XXQuestionCell *)toolbar.superview.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}



@end
