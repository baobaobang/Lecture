//
//  XXBaseVC.h
//  Lecture
//
//  Created by 陈旭 on 16/1/24.
//  Copyright © 2016年 陈旭. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface XXBaseVC : UIViewController

-(void)showNetworkIndicator;

-(void)hideNetworkIndicator;

-(void)showProgress;

-(void)hideProgress;

-(void)alert:(NSString*)msg;

-(BOOL)alertError:(NSError*)error;

-(BOOL)filterError:(NSError*)error;

-(void)runInMainQueue:(void (^)())queue;

-(void)runInGlobalQueue:(void (^)())queue;

-(void)runAfterSecs:(float)secs block:(void (^)())block;

-(void)showHUDText:(NSString*)text;

@end
