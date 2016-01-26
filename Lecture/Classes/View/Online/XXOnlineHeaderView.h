//
//  XXOnlineHeaderView.h
//  Lecture
//
//  Created by 陈旭 on 16/1/26.
//  Copyright © 2016年 陈旭. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XXOnlineHeaderView;

@protocol XXOnlineHeaderViewDelegate <NSObject>

@optional
- (void)onlineHeaderView:(XXOnlineHeaderView *)headerView didClickContractBtn:(UIButton *)btn;

@end

@interface XXOnlineHeaderView : UIView
@property (nonatomic, weak) id<XXOnlineHeaderViewDelegate> delegate;

@end
