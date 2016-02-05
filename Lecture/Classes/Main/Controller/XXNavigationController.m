//
//  XXNavigationController.m
//  黑马微博2期
//
//  Created by apple on 14-10-7.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "XXNavigationController.h"

@interface XXNavigationController ()

@end

@implementation XXNavigationController

+ (void)initialize
{
    // 设置导航栏的统一样式
    UINavigationBar *navBar = [UINavigationBar appearance];
    // 导航栏背景色
    navBar.barTintColor = XXColorTint;
    // 设置返回，左，右 item的字体颜色
    [navBar setTintColor:XXColorText];
    
    // 设置标题
    NSMutableDictionary *titleAttrs = [NSMutableDictionary dictionary];
    // 标题颜色
    titleAttrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
    // 标题字体
    titleAttrs[NSFontAttributeName] = [UIFont boldSystemFontOfSize:20];
    navBar.titleTextAttributes = titleAttrs;

}


- (void)viewDidLoad
{
    [super viewDidLoad];
}

/**
 *  重写这个方法目的：能够拦截所有push进来的控制器
 *
 *  @param viewController 即将push进来的控制器
 */
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count > 0) { // 这时push进来的控制器viewController，不是第一个子控制器（不是根控制器）
        /* 设置导航栏上面的内容 */
        // 设置左边的返回按钮
        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(back) bgImageStr:@"before_nav_back" bgHighImageStr:@"before_nav_back"];
    }
    
    [super pushViewController:viewController animated:animated];
}

- (void)back
{
    [self popViewControllerAnimated:YES];
}

@end
