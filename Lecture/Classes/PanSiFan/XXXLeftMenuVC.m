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

@interface XXXLeftMenuVC ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation XXXLeftMenuVC

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.tableView.delegate = self;
//    self.tableView.dataSource = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma -tableView代理,数据源


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuseStr = @"MenuCell";
    UITableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:reuseStr];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseStr];
    }
    NSString *title;
    switch (indexPath.row) {
        case 0:
            title = @"首页";
            break;
        case 1:
            title = @"个人中心";
            break;
        case 2:
            title = @"登录";
            break;
        default:
            break;
    }
    cell.textLabel.text = title;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
            
            break;
        case 1:
            
            break;
        case 2:
        {
            //XXXLoginVC *lvc = [[XXXLoginVC alloc]init];
            XXXRegisterVC *lvc = [[XXXRegisterVC alloc]init];
            AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [delegate.sliderMenu changeMainViewController:lvc close:YES];
            
        }
            break;
        default:
            break;
    }
}

@end
