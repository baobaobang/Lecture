//
//  XXXBaseVC.h
//  lecture
//
//  Created by mortal on 16/1/22.
//  Copyright © 2016年 禾医健康科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXNavigationController.h"
@interface XXXBaseVC : UIViewController
@property (nonatomic, strong) UIView *nav;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *navRightView;
@property (nonatomic, strong) UIImageView *navLeftView;

//导航栏左按钮事件
- (void)navLeftAction;
//导航栏右按钮事件
- (void)navRightAcion;
@end
