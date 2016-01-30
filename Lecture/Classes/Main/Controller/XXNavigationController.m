//
//  XXNavigationController.m
//  黑马微博2期
//
//  Created by apple on 14-10-7.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "XXNavigationController.h"
#import "XXLectureHomeVC.h"
//#import "XXLectureVC.h"

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


//支持旋转
-(BOOL)shouldAutorotate{
    // self.topViewController是当前导航显示的UIViewController，这样就可以控制每个UIViewController所支持的方向啦！
    if ([self.topViewController isKindOfClass:[XXLectureHomeVC class]]) {
        return YES;
    }
    return NO;
}
//支持的方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if ([self.topViewController isKindOfClass:[XXLectureHomeVC class]]) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    }
    return UIInterfaceOrientationMaskPortrait;
}


@end
