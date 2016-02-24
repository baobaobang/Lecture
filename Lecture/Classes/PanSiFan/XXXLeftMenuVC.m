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

@interface XXXLeftMenuVC ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *titlesArray;
@end

@implementation XXXLeftMenuVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titlesArray = [NSMutableArray arrayWithArray:@[@"首页",@"登录"]];
//    self.tableView.delegate = self;
//    self.tableView.dataSource = self;
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
        cell.imageView.frame = CGRectMake(0, 0, 40, 40);
    }
    //cell.imageView.image = [UIImage imageNamed:@"logo"];
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
                [self.titlesArray replaceObjectAtIndex:1 withObject:@"登录"];
                [self.tableView reloadData];
            }else{
                XXXLoginVC *lvc = [[XXXLoginVC alloc]init];
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
