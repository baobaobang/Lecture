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
#import "XXExpert.h"

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

@property (nonatomic, strong) NSArray *questions;
@property (nonatomic, strong) NSArray *experts;

@end

@implementation XXLectureViewController

static NSString * const expertHeaderId = @"expertHeaderId";
static NSString * const questionHeaderId = @"questionHeaderId";

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
    
    // 注册headerview
    [self.tableView registerNib:[UINib nibWithNibName:@"XXExpertProfileHeaderView" bundle:nil] forHeaderFooterViewReuseIdentifier:expertHeaderId];
    [self.tableView registerNib:[UINib nibWithNibName:@"XXQuestionHeaderView" bundle:nil] forHeaderFooterViewReuseIdentifier:questionHeaderId];
}

- (NSArray *)questions
{
    if (!_questions) {
        _questions = [XXQuestion objectArrayWithFilename:@"Questions.plist"];
        // 按照点赞数排序
        _questions = [_questions sortedArrayUsingSelector:@selector(compareAttitudesCount:)];
    }
    return _questions;
}

- (NSArray *)experts
{
    if (!_experts) {
        _experts = [XXExpert objectArrayWithFilename:@"Experts.plist"];
    }
    return _experts;
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
    if (indexPath.section == XXExpertProfileSection) {// 专家简介section
        XXExpertProfileCell *expertCell = [XXExpertProfileCell expertProfileCellInTableView:tableView];
        expertCell.expert = self.experts[indexPath.row];

        return expertCell;
        
    }else{// 精选提问section
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
        
        // 给cell的子控件赋值
        questionCell.question = self.questions[indexPath.row];
        
        return questionCell;
    }
}

#pragma mark - 自定义的headerView
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == XXExpertProfileSection) {
        XXExpertProfileHeaderView *expertHeader = (XXExpertProfileHeaderView *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:expertHeaderId];
        return expertHeader;
    }else{
        XXQuestionHeaderView *questionHeader = (XXQuestionHeaderView *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:questionHeaderId];
        return questionHeader;
    }
}

#pragma mark - headerView的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 35;
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
            XXQuestion *question = self.questions[indexPath.row];
            [questionCell cellAutoLayoutHeight:question.content];
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
    
//    [tableView reloadData];
    
    // 一般在UITableView执行：删除行，插入行，删除分组，插入分组时，使用下面两句来协调UITableView的动画效果。
    [tableView beginUpdates];
    [tableView endUpdates];
}

#pragma mark - XXQuestionToolbar的按钮被点击了
- (void)questionToolbar:(XXQuestionToolbar *)toolbar didClickBtnType:(XXQuestionToolbarButtonType)type{
    
    if (type == XXQuestionToolbarButtonTypeUnlike) {// 点击点赞按钮
        
        // 将将question数组排序按照点赞数来排序，再刷新表格和cell顺序
        NSUInteger oldRow = [self.questions indexOfObject:toolbar.question];
        NSIndexPath *oldIndexPath = [NSIndexPath indexPathForRow:oldRow inSection:XXQuestionSection];
        [self.tableView reloadRowsAtIndexPaths:@[oldIndexPath] withRowAnimation:UITableViewRowAnimationNone];// 先刷新点赞数目
        
        self.questions = [self.questions sortedArrayUsingSelector:@selector(compareAttitudesCount:)];
        NSUInteger newRow = [self.questions indexOfObject:toolbar.question];
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:newRow inSection:XXQuestionSection];
        
        [self.tableView moveRowAtIndexPath:oldIndexPath toIndexPath:newIndexPath];// 再移动cell顺序
        
    }else{// 点击分享和评论按钮
        
        XXQuestionCell *cell = (XXQuestionCell *)toolbar.superview.superview.superview;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
}



@end
