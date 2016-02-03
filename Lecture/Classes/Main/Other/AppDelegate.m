//
//  AppDelegate.m
//  Lecture
//
//  Created by 陈旭 on 16/1/7.
//  Copyright © 2016年 陈旭. All rights reserved.
//

#import "AppDelegate.h"
#import "XXHomeVC.h"
#import "XXNavigationController.h"
#import "XXLectureJoinVC.h"
#import "XXLectureHomeVC.h"

#import "XXXLoginVC.h"
#import "XXXMainPageVC.h"
#import "AppDelegate+UM.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //友盟相关
    [self UMApplication:application didFinishLaunchingWithOptions:launchOptions];
    
    UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    window.backgroundColor = [UIColor whiteColor];
    
    XXHomeVC *rootVc = [[XXHomeVC alloc] init]; // 首页
//    XXLectureJoinVC *rootVc = [[XXLectureJoinVC alloc] init]; // 讲座前
//    XXLectureHomeVC *rootVc =[[XXLectureHomeVC alloc] init]; // 讲座中
    

    rootVc.view.frame = window.frame;

    XXNavigationController *nav = [[XXNavigationController alloc] initWithRootViewController:rootVc];
    
    window.rootViewController = nav;
    
    [window makeKeyAndVisible];
    self.window = window;
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // 开启后台任务，让程序后台运行
    UIBackgroundTaskIdentifier identifier = [application beginBackgroundTaskWithExpirationHandler:^{
        [application endBackgroundTask:identifier];
    }];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
