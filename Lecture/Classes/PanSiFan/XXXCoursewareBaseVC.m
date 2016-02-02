//
//  ViewController.m
//  Upload
//
//  Created by mortal on 16/1/11.
//  Copyright © 2016年 禾医健康科技. All rights reserved.
//

#import "XXXCoursewareBaseVC.h"
#import "XXXOnlineCoursewareVC.h"
#import "TipView.h"
@interface XXXCoursewareBaseVC ()<TipViewDelegate>
@property (nonatomic, strong) UIButton *addBtn;//添加页面的按钮
@property (nonatomic, strong) XXXOnlineCoursewareVC *curVC;//当前操作的view

@end

@implementation XXXCoursewareBaseVC

- (UIScrollView *)titleTips{
    if (!_titleTips) {
        _titleTips = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64,SWIDTH , 30)];
        _titleTips.showsHorizontalScrollIndicator = NO;
        _titleTips.backgroundColor = [UIColor whiteColor];
        _titleTips.contentSize = CGSizeMake(SWIDTH, 30);
        _addBtn = [[UIButton alloc]initWithFrame:CGRectMake(3,0, 30, 30)];
        [_addBtn setBackgroundImage:[UIImage imageNamed:@"backimg"] forState:0];
        //[button setTitle:_pageLabel.text forState:0];
        [_addBtn addTarget:self action:@selector(addpage) forControlEvents:UIControlEventTouchUpInside];
        [_titleTips addSubview:_addBtn];
        [self.view addSubview:_titleTips];
        
        //[_addBtn shadow];
        
    }
    return _titleTips;
}

- (NSMutableArray<UIViewController *> *)childs{

    if (!_childs) {
        _childs = [NSMutableArray array];
    }
    return _childs;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}
- (void)viewDidLoad{
    [super viewDidLoad];
    UIView *nav = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SWIDTH,64)];
    nav.backgroundColor = navColor;
    [self.view addSubview:nav];
    
    UIImageView *leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"back-1"]];
    leftView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(back)];
    
    [leftView addGestureRecognizer:tap];
    
    leftView.frame = CGRectMake(10, 30, 20, 20);
    [nav addSubview:leftView];
    UIImageView *rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"e"]];
    rightView.frame = CGRectMake(SWIDTH-40, 30, 20, 20);
    [nav addSubview:rightView];
    [self addpage];
}

- (void)addpage{
    XXXOnlineCoursewareVC *onv = [XXXOnlineCoursewareVC onlineCoursewareWithSupperVC:self];
    self.curVC = onv;
    onv.page = self.childs.count+1;
    [self.childs addObject:onv];
    //[self.titleTips addSubview:onv.view];
    [self.view addSubview:onv.view];
    
    TipView *button = [[TipView alloc]initWithFrame:CGRectMake(3+(53*self.childs.count-53),0, 50, 30)];
    button.tag = onv.page+1000;
    button.delegate = self;
    button.selected = YES;
    [button setTitle:[NSString stringWithFormat:@"%ld",onv.page] forState:0];
    for (UIView *v in _titleTips.subviews) {
        if ([v isKindOfClass:[TipView class]]) {
            ((TipView *)v).selected = NO;
        }
    }
    [self.titleTips addSubview:button];
    [button shadow];
    
    _addBtn.frame = CGRectOffset(_addBtn.frame, 53, 0);
    self.titleTips.contentSize = CGSizeMake(CGRectGetMaxX(_addBtn.frame), 30);
    
    [self.view bringSubviewToFront:_titleTips];
}

- (void)selectPage:(UIButton *)sender{
    if (sender.tag -1000 == self.curVC.page) {
        return;
    }
    for (NSInteger i = 0; i<self.childs.count; i++) {
        XXXOnlineCoursewareVC *onv = (XXXOnlineCoursewareVC *)self.childs[i];
        if (onv.page == sender.tag-1000) {
            //[self.view bringSubviewToFront:onv.view];
            [self.view insertSubview:onv.view belowSubview:self.curVC.view];
            
            [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:1 initialSpringVelocity:3 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                onv.view.frame = CGRectMake(-SWIDTH/2 - 20, 93, SWIDTH, SHEIGHT);
                self.curVC.view.frame = CGRectMake(SWIDTH/2 + 20, 93, SWIDTH, SHEIGHT);
            } completion:^(BOOL finished) {
                
                [self.view bringSubviewToFront:onv.view];
                [self.view bringSubviewToFront:_titleTips];
                [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:1 initialSpringVelocity:3 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    onv.view.frame = CGRectMake(0, 93, SWIDTH, SHEIGHT);
                    self.curVC.view.frame = CGRectMake(0, 93, SWIDTH, SHEIGHT);
                } completion:^(BOOL finished) {
                    self.curVC = onv;
                }];
            }];
            
            
        }
        
    }
}

- (void)tipView:(TipView *)tipView closeIndex:(NSInteger)index{
    [self remove:tipView];
}
- (void)tipView:(TipView *)tipView clickAtIndex:(NSInteger)index{
    [self selectPage:tipView];
    for (UIView *v in _titleTips.subviews) {
        if ([v isKindOfClass:[TipView class]] && tipView.tag != v.tag) {
            ((TipView *)v).selected = NO;
        }
    }
    [self.view bringSubviewToFront:_titleTips];
}

- (void)remove:(UIButton *)sender{
    //NSLog(@"%ld",sender.tag);
    if (self.childs.count == 1) {
        return;
    }
    for (NSInteger i = 0; i<self.childs.count; i++) {
        XXXOnlineCoursewareVC *onv = (XXXOnlineCoursewareVC *)self.childs[i];
        if (onv.page == sender.tag-1000) {
            [sender removeFromSuperview];
            [self.childs removeObject:onv];
            i--;
            [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:1 initialSpringVelocity:3 options:UIViewAnimationOptionCurveEaseIn animations:^{
                
                onv.view.frame = CGRectOffset(onv.view.frame, -SWIDTH, 0);
                _addBtn.frame = CGRectOffset(_addBtn.frame, -53, 0);
                for (UIButton *tip in self.titleTips.subviews) {
                    if (tip.tag>sender.tag) {
                        tip.frame = CGRectOffset(tip.frame, -53, 0);
                        tip.tag -= 1;
                        [tip setTitle:[NSString stringWithFormat:@"%ld",tip.tag-1000] forState:0];
                    }
                }
            } completion:^(BOOL finished) {
                [onv.view removeFromSuperview];
                self.titleTips.contentSize = CGSizeMake(CGRectGetMaxX(_addBtn.frame), 30);
            }];
            
        }
        onv.page = [self.childs indexOfObject:onv]+1;
        NSLog(@"%ld",onv.page);
    }
    
}

- (void)back{
    [self dismissViewControllerAnimated:YES completion:nil];
}
//- (void)remove:(UIButton *)sender{
//    //NSLog(@"%ld",sender.tag);
//    for (NSInteger i = 0; i<self.childs.count; i++) {
//        XXXOnlineCoursewareVC *onv = (XXXOnlineCoursewareVC *)self.childs[i];
//        if (onv.page == sender.tag-1000) {
//            [sender removeFromSuperview];
//            _addBtn.frame = CGRectOffset(_addBtn.frame, -53, 0);
//            for (UIButton *tip in self.titleTips.subviews) {
//                if (tip.tag>sender.tag) {
//                    tip.frame = CGRectOffset(tip.frame, -53, 0);
//                    tip.tag -= 1;
//                    [tip setTitle:[NSString stringWithFormat:@"%ld",tip.tag-1000] forState:0];
//                }
//            }
//            
//            [onv.view removeFromSuperview];
//            self.titleTips.contentSize = CGSizeMake(CGRectGetMaxX(_addBtn.frame), 21);
//            
//            [self.childs removeObject:onv];
//            i--;
//        }
//        onv.page = [self.childs indexOfObject:onv]+1;
//        NSLog(@"%ld",onv.page);
//    }
//    
//}
@end
