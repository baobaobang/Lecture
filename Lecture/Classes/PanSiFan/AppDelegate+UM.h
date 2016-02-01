//
//  AppDelegate+UM.h
//  lecture
//
//  Created by mortal on 16/1/21.
//  Copyright © 2016年 禾医健康科技. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (UM)

- (void)UMApplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;

@end
