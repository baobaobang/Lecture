//
//  XXXProtocolTipView.m
//  Lecture
//
//  Created by mortal on 16/2/3.
//  Copyright © 2016年 陈旭. All rights reserved.
//

#import "XXXProtocolTipView.h"
#import "UIView+RoundAndShadow.h"
#import <WebKit/WebKit.h>
@implementation XXXProtocolTipView


- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView *contanner = [[UIView alloc]initWithFrame:self.bounds];
        [self shadow];
        contanner.layer.cornerRadius = 10;
        contanner.layer.masksToBounds = YES;
        UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, 44)];
        title.text = @"用户注册协议";
        title.textColor = [UIColor whiteColor];
        title.textAlignment = NSTextAlignmentCenter;
        title.backgroundColor = RGB(81, 220, 147);
        [contanner addSubview:title];
        
        UIButton *close = [[UIButton alloc]initWithFrame:CGRectMake(frame.size.width - 36, 8, 32, 32)];
        [close setBackgroundImage:[UIImage imageNamed:@"close"] forState:0];
        [close addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
        [contanner addSubview:close];
        
        WKWebView *webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 44, frame.size.width, frame.size.height-44)];
        [contanner addSubview:webView];
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"protocol" withExtension:@"html"];
        [webView loadFileURL:url allowingReadAccessToURL:url];
        [self addSubview:contanner];
        
        
    }
    return self;
}


- (void)close{
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.transform = CGAffineTransformMakeScale(0.01, 0.01);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
@end
