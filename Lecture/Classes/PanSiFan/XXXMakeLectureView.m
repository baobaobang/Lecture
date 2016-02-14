//
//  XXXMakeLectureView.m
//  Lecture
//
//  Created by mortal on 16/2/1.
//  Copyright © 2016年 陈旭. All rights reserved.
//

#import "XXXMakeLectureView.h"
#define PlusBtnW 50.0
@interface XXXMakeLectureView()

@property (nonatomic, assign) BOOL isOpen;//按钮收缩状态
@property (nonatomic, assign) CGRect rect;

@end
@implementation XXXMakeLectureView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.isOpen = NO;
        
        for (NSInteger i = 0; i<5; i++) {
            NSArray *titles = @[@"发布讲座",@"我的讲座",@"回复",@"草稿箱",@""];
            UIButton *btn = [[UIButton alloc]initWithFrame:self.rect];
            btn.tag = 1000+i;
            [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [btn setTitle:titles[i] forState:0];
            btn.titleLabel.font = [UIFont systemFontOfSize:12];
            btn.layer.cornerRadius = btn.frame.size.width/2;
            
            if (i == 4) {
                [btn setBackgroundImage:[[UIImage imageNamed:@"plus"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]forState:0];
                [btn setTintColor:[UIColor whiteColor]];
            }
            [self addSubview:btn];
            btn.backgroundColor = navColor;
        }
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
        [self addGestureRecognizer:tap];
        self.clipsToBounds = NO;
    }
    return self;
}

- (void)btnClicked:(UIButton *)sender{
    switch (sender.tag) {
    
        case 1004://点击了加号
            [self animateBtns:sender];
            break;
        
        default://点击其他按钮 由代理处理
            [self.delegate XXXMakeLectureView:self clickedIndex:sender.tag-1000];
            break;
    }
}

/**
 *  按钮动画
 */
- (void)animateBtns:(UIButton *)plus{

    if (!self.isOpen) {
        self.frame =CGRectMake(0, SHEIGHT-150, SWIDTH, 150);
        
        for (UIButton *sender in self.subviews) {
            sender.frame = self.rect;
        }
        
        CGVector vector;
        
        for (UIButton *sender in self.subviews) {
            switch (sender.tag) {
                case 1000:
                    vector = CGVectorMake(-100, -10);
                    break;
                case 1001:
                    vector = CGVectorMake(-50, -70);
                    break;
                case 1002:
                    vector = CGVectorMake(50, -70);
                    break;
                case 1003:
                    vector = CGVectorMake(100, -10);
                    break;
                default:
                    vector = CGVectorMake(0, 0);
                    break;
            }
            CGFloat delay = 0.2+ (sender.tag-1000)*0.05;
            if (sender.tag == 1004) {
                delay = 0.2;
            }
            [UIView animateWithDuration:0.5 delay:delay usingSpringWithDamping:0.7 initialSpringVelocity:3 options:UIViewAnimationOptionCurveEaseOut animations:^{
                if (sender.tag != 1004) {
                    sender.frame = CGRectOffset(sender.frame, vector.dx, vector.dy);
                }else{
                    sender.layer.transform = CATransform3DMakeRotation(M_PI_4*3, 0, 0, 1);
                    //[sender setTintColor:[UIColor redColor]];
                }
                
            } completion:^(BOOL finished) {
                
            }];
            
        }
    }else{
        
        
        
        for (UIButton *sender in self.subviews) {
            
            CGFloat delay = 0.2+ (sender.tag-1000)*0.05;
            if (sender.tag == 1004) {
                delay = 0.2;
            }
            [UIView animateWithDuration:0.5 delay:delay usingSpringWithDamping:1 initialSpringVelocity:3 options:UIViewAnimationOptionCurveEaseIn animations:^{
                if (sender.tag != 1004) {
                    sender.frame = self.rect;
                }else{
                    sender.layer.transform = CATransform3DMakeRotation(0, 0, 0, 1);
                }
            } completion:^(BOOL finished) {
            }];    
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.frame = CGRectMake(SWIDTH/2-25, SHEIGHT-100, 50, 100);
            for (UIButton *sender in self.subviews) {
                sender.frame = self.rect;
            }
        });
    }
    self.isOpen = !self.isOpen;
}

- (void)tap:(UITapGestureRecognizer *)tap {
    [self animateBtns:nil];
}

-(CGRect)rect{
    return CGRectMake(self.frame.size.width/2-PlusBtnW/2, self.frame.size.height-PlusBtnW-20, PlusBtnW, PlusBtnW);
}

@end
