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
    navBar.barTintColor = XXTintColor;
    // 设置返回，左，右 item的字体颜色
    [navBar setTintColor:XXTintTitleColor];
    
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

//// 设置BarButtonItem文字的主题样式
//+ (void)setupBarButtonItem{
//    
//    // 设置整个项目
//    UIBarButtonItem *item = [UIBarButtonItem appearance];
//    // 设置普通状态
//    // key：NS****AttributeName
//    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
//    // 字体颜色
//    textAttrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
//    // 字体大小
//    textAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:15];
//    [item setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
//    
//    
//    // 设置不可用状态
//    //    NSMutableDictionary *disableTextAttrs = [NSMutableDictionary dictionary];
//    //    disableTextAttrs[NSForegroundColorAttributeName] = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:0.7];
//    //    disableTextAttrs[NSFontAttributeName] = textAttrs[NSFontAttributeName];
//    //    [item setTitleTextAttributes:disableTextAttrs forState:UIControlStateDisabled];
//}


///**
// *  重写这个方法目的：能够拦截所有push进来的控制器
// *
// *  @param viewController 即将push进来的控制器
// */
//- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
//{
//    if (self.viewControllers.count > 0) { // 这时push进来的控制器viewController，不是第一个子控制器（不是根控制器）
//        /* 自动显示和隐藏tabbar */
//        viewController.hidesBottomBarWhenPushed = YES;
//        
//        /* 设置导航栏上面的内容 */
//        // 设置左边的返回按钮
//        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(back) image:@"navigationbar_back" highImage:@"navigationbar_back_highlighted"];
//        
//        // 设置右边的更多按钮
//        viewController.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(more) image:@"navigationbar_more" highImage:@"navigationbar_more_highlighted"];
//    }
//
//    [super pushViewController:viewController animated:animated];
//}
//
//- (void)back
//{
//#warning 这里要用self，不是self.navigationController
//    // 因为self本来就是一个导航控制器，self.navigationController这里是nil的
//    [self popViewControllerAnimated:YES];
//}
//
//- (void)more
//{
//    [self popToRootViewControllerAnimated:YES];
//}

@end
