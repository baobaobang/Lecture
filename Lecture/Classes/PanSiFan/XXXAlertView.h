//
//  XXXAlertView.h
//  Lecture
//
//  Created by mortal on 16/2/17.
//  Copyright © 2016年 陈旭. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XXXAlertView : UIView

@property (nonatomic, weak)  UILabel *title;
@property (nonatomic, strong) UIView *contanner;

//关闭
- (void)close;

/**
 *  在某个view内显示
 *
 *  @param view
 */
- (void)alertInView:(UIView *)view;
@end
