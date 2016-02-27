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
#import "XXXLoginVC.h"
#import "XXXMainPageVC.h"
#import "AppDelegate+UM.h"
#import "XXXLeftMenuVC.h"
#import "DBManager.h"
#import "AFNetworkReachabilityManager.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    if (!UserDefaultsGet(@"FIRST_LAUNCH")) {
        UserDefaultsSave(@"LAUNCHED_FLAG", @"FIRST_LAUNCH");
        //初始化数据库
        [self readyFMDB];
    }
    
    //友盟相关
    
    [self UMApplication:application didFinishLaunchingWithOptions:launchOptions];

    
    
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    
    
    XXNavigationController *nav = [[XXNavigationController alloc]initWithRootViewController:[[XXXMainPageVC alloc]init]];
//    SlideMenuController *sliderMenuVC = [[SlideMenuController alloc] initWithMainViewController:nav leftMenuViewController:[[XXXLeftMenuVC alloc]init] rightMenuViewController:nil];
    SlideMenuController *sliderMenuVC = [[SlideMenuController alloc] initWithMainViewController:nav leftMenuViewController:[[XXXLeftMenuVC alloc]init]];
    [sliderMenuVC changeLeftViewWidth:150];
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = sliderMenuVC;
    self.sliderMenu = sliderMenuVC;
    [sliderMenuVC addLeftGestures];
    [self.window makeKeyAndVisible];
    
    [self getQNToken];
    
    [self DetectionNetwork];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // 开启后台任务，让程序后台运行
    UIBackgroundTaskIdentifier identifier = [application beginBackgroundTaskWithExpirationHandler:^{
        [application endBackgroundTask:identifier];
    }];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {
    
}

-(void) getQNToken{
    [NetworkManager getWithApi:@"qiniu/token" params:nil success:^(id result) {
        UserDefaultsSave(result[@"token"], @"qiniutoken");
    } fail:^(NSError *error) {
        
    }];
}
// 检测网络
- (void)DetectionNetwork
{
    // 1.获得网络监控的管理者
    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
    // 2.设置网络状态改变后的处理
    [mgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        // 当网络状态改变了, 就会调用这个block
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:{ // 未知网络
                //NSLog(@"未知网络");
            }
                break;
                
            case AFNetworkReachabilityStatusNotReachable:{ // 没有网络(断网)
                [SVProgressHUD showInfoWithStatus:@"没有网络啦"];
            }
                break;
                
            case AFNetworkReachabilityStatusReachableViaWWAN:{ // 手机自带网络
                //[SVProgressHUD showInfoWithStatus:@"切换到手机网络"];
            }
                break;
                
            case AFNetworkReachabilityStatusReachableViaWiFi:{ // WIFI
                //[SVProgressHUD showInfoWithStatus:@"切换到WIFI"];
            }
                break;
        }
    }];
    // 3.开始监控
    [mgr startMonitoring];
}


/**
 *
 */
- (void)readyFMDB{
    NSString *document = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *path = [document stringByAppendingPathComponent:@"LectureRoom.db"];
    FMDatabase *db = [FMDatabase databaseWithPath:path];
    [DBManager shareDBManager].db = db;
    
    if ([db open]) {
        [db executeStatements:@"create table t_Lecture (id integer primary key autoincrement, LectureId text, expertId text, StartDate text, Duration integer, OnlineDuration integer, Title text, Desc text, Cover text,Hospital text, Department text, Introduction text, JobTitle text, Speciality text, Name text, HeadPic text)"];
        [db  executeStatements:@"create table t_LecturePage (id integer primary key autoincrement,LectureId text, PageNo integer, Title text, Picture text, Audio text, LocalImage blob)"];
    }
    [db close];
    
    
    
}
@end
