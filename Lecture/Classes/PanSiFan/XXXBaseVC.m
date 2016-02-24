//
//  XXXBaseVC.m
//  lecture
//
//  Created by mortal on 16/1/22.
//  Copyright © 2016年 禾医健康科技. All rights reserved.
//

#import "XXXBaseVC.h"

@implementation XXXBaseVC

- (void)viewDidLoad{
    [super viewDidLoad];
    //self.navigationController.navigationBar.barTintColor = navColor;
    UIView *nav = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SWIDTH,64)];
    nav.backgroundColor = navColor;
    [self.view addSubview:nav];
    self.nav = nav;
    UIImageView *leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"back-1"]];
    leftView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(navLeftAction)];
    
    [leftView addGestureRecognizer:tap];
    
    leftView.frame = CGRectMake(15, 30, 20, 20);
    [nav addSubview:leftView];
    UIImageView *rightView = [[UIImageView alloc] initWithFrame:CGRectMake(SWIDTH-40, 30, 20, 20)];
    //rightView.frame = CGRectMake(SWIDTH-40, 30, 20, 20);
    
    rightView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(navRightAcion)];
    
    [rightView addGestureRecognizer:tap2];
    
    self.navRightView = rightView;
    self.navLeftView = leftView;
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(SWIDTH/2-50, 30, 100, 20)];
    
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    titleLabel.textColor = [UIColor whiteColor];
    
    self.titleLabel = titleLabel;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [nav addSubview:titleLabel];
    [nav addSubview:rightView];
    
    
}

- (void)back{
    [self dismissViewControllerAnimated:YES completion:nil];
}


//导航栏左按钮事件
- (void)navLeftAction{
    [self back];
}
//导航栏右按钮事件
- (void)navRightAcion{

}

@end
