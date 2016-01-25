//
//  XXExpertProfileHeaderView.h
//  Lecture
//
//  Created by 陈旭 on 16/1/10.
//  Copyright © 2016年 陈旭. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XXExpert, XXExpertProfileHeaderView;
@protocol XXExpertProfileHeaderViewDelegate <NSObject>

@optional
- (void)expertProfileHeaderView:(XXExpertProfileHeaderView *)headerView didClickFollowBtn:(UIButton *)btn;
@end
@interface XXExpertProfileHeaderView : UIView

@property (nonatomic, strong) XXExpert *expert;
//+ (instancetype)headerViewInTableView:(UITableView *)tableView;
@property (nonatomic, weak) id<XXExpertProfileHeaderViewDelegate> delegate;
@end
