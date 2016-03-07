//
//  XXXLeftMenuVC.m
//  Lecture
//
//  Created by mortal on 16/2/14.
//  Copyright © 2016年 陈旭. All rights reserved.
//

#import "XXXLeftMenuVC.h"
#import "XXXLoginVC.h"
#import "XXXRegisterVC.h"
#import "XXXMainPageVC.h"
#import "XXNavigationController.h"
#import "UIView+RoundAndShadow.h"

@interface XXXLeftMenuVC ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *titlesArray;
@end

@implementation XXXLeftMenuVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    self.titlesArray = [NSMutableArray arrayWithArray:@[@"首页",@"登录"]];
    
    [self setAvataView];
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.backgroundColor = [UIColor clearColor];
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    UIVisualEffectView *blurView = [[UIVisualEffectView alloc]initWithEffect:effect];
    blurView.frame = self.tableView.bounds;
    self.tableView.backgroundView = blurView;
}


- (void)setAvataView{
    UIView *tableViewHeader = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SWIDTH, 150)];
    UIImageView *avata = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    avata.backgroundColor = [UIColor grayColor];
    avata.layer.cornerRadius = 25;
    avata.clipsToBounds = YES;
    UIView *bac = [[UIView alloc]initWithFrame:CGRectMake(40, 40, 50, 50)];
    avata.layer.borderColor = [UIColor whiteColor].CGColor;
    avata.layer.borderWidth =2;
    [bac shadow];
    [bac addSubview:avata];
    [tableViewHeader addSubview:bac];
    
    UILabel *nickName = [[UILabel alloc]initWithFrame:CGRectMake(-10, 100, 150, 15)];
    nickName.textAlignment = NSTextAlignmentCenter;
    nickName.font = [UIFont systemFontOfSize:10];
    nickName.textColor = RGB(51, 51, 51);
    nickName.text =  @"未填写";
    [tableViewHeader addSubview:nickName];
    
    
    UILabel *jobTitle = [[UILabel alloc]initWithFrame:CGRectMake(-10, 120, 150, 15)];
    jobTitle.textAlignment = NSTextAlignmentCenter;
    jobTitle.font = [UIFont systemFontOfSize:10];
    jobTitle.textColor = RGB(51, 51, 51);
    jobTitle.text =  @"点击补全资料";
    [tableViewHeader addSubview:jobTitle];
    
    
    UIButton *finishInfo = [[UIButton alloc]initWithFrame:CGRectMake(40, 40, 50, 95)];
    [finishInfo addTarget:self action:@selector(finishInfo) forControlEvents:UIControlEventTouchUpInside];
    [tableViewHeader addSubview:finishInfo];
    self.tableView.tableHeaderView = tableViewHeader;
}


- (void)finishInfo{
    NSLog(@"补全资料");
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [delegate.sliderMenu closeLeft];
//    XXXMainPageVC *mainPage = (XXXMainPageVC *)delegate.sliderMenu.mainViewController;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSNotification *note = [[NSNotification alloc]initWithName:NOTIFICATION_TOFINISHINFO object:nil userInfo:nil];
        [[NSNotificationCenter defaultCenter] postNotification:note];
    });
    
}
- (void)viewWillAppear:(BOOL)animated{
    if (ACCESS_TOKEN) {
        [self.titlesArray replaceObjectAtIndex:1 withObject:@"退出登录"];
        [self.tableView reloadData];
    }
}
#pragma -tableView代理,数据源


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titlesArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuseStr = @"MenuCell";
    UITableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:reuseStr];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseStr];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.textColor = RGB(51, 51, 51);
        cell.backgroundColor = [UIColor clearColor];
    }
    cell.textLabel.text = _titlesArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
        {
            XXXMainPageVC *mp = [[XXXMainPageVC alloc]init];
            XXNavigationController *nav = [[XXNavigationController alloc]initWithRootViewController:mp];
            AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [delegate.sliderMenu changeMainViewController:nav close:YES];
        }
            break;
        case 1:
        {
            if (ACCESS_TOKEN) {
                UserDefaultsSave(nil, @"access_token");
                UserDefaultsSave(nil,@"isExpert");
                [self.titlesArray replaceObjectAtIndex:1 withObject:@"登录"];
                [self.tableView reloadData];
                
                XXXMainPageVC *lvc = [[XXXMainPageVC alloc]init];
                XXNavigationController *nav = [[XXNavigationController alloc]initWithRootViewController:lvc];
                AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                [delegate.sliderMenu changeMainViewController:nav close:YES];
            }else{
                XXXLoginVC *lvc = [[XXXLoginVC alloc]init];
                lvc.fromLeftMenu = YES;
                XXNavigationController *nav = [[XXNavigationController alloc]initWithRootViewController:lvc];
                AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                [delegate.sliderMenu changeMainViewController:nav close:YES];
            }
            
            
        }
            break;
        default:
            break;
    }
}

@end
