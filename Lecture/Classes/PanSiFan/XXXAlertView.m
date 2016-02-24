//
//  XXXAlertView.m
//  Lecture
//
//  Created by mortal on 16/2/17.
//  Copyright © 2016年 陈旭. All rights reserved.
//

#import "XXXAlertView.h"
#import "UIView+RoundAndShadow.h"

@implementation XXXAlertView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _contanner = [[UIView alloc]initWithFrame:self.bounds];
        [self shadow];
        _contanner.layer.cornerRadius = 10;
        _contanner.layer.masksToBounds = YES;
        UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, 44)];
        title.textColor = [UIColor whiteColor];
        title.textAlignment = NSTextAlignmentCenter;
        title.backgroundColor = RGB(81, 220, 147);
        [_contanner addSubview:title];
        
        UIButton *close = [[UIButton alloc]initWithFrame:CGRectMake(frame.size.width - 36, 8, 32, 32)];
        [close setBackgroundImage:[UIImage imageNamed:@"close"] forState:0];
        [close addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
        [_contanner addSubview:close];
        [self addSubview:_contanner];
        _contanner.backgroundColor = [UIColor whiteColor];
        
        
    }
    return self;
}


- (void)close{
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:1 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.transform = CGAffineTransformMakeScale(0.01, 0.01);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)alertInView:(UIView *)view{
    [view addSubview:self];
    self.transform = CGAffineTransformMakeScale(0, 0);
    [UIView animateWithDuration:.5 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.transform = CGAffineTransformMakeScale(1, 1);
    } completion:^(BOOL finished) {
        
    }];
}
@end
