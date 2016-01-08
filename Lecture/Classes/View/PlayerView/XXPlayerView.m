//
//  XXPlayerView.m
//  Lecture
//
//  Created by 陈旭 on 16/1/7.
//  Copyright © 2016年 陈旭. All rights reserved.
//

#import "XXPlayerView.h"

#define PhotoCount 4

@interface XXPlayerView () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *pptView;
@property (weak, nonatomic) IBOutlet UIView *playerToolBar;
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *imageViews;
@end


@implementation XXPlayerView
+ (instancetype)playerView{
    return [[[NSBundle mainBundle] loadNibNamed:@"XXPlayerView" owner:nil options:nil] lastObject];
}


// 初始化子控件
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {

    }
    return self;
}


- (void)awakeFromNib{
    
    // 1.创建一个scrollView：用于显示所有的ppt图片
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    [self.pptView addSubview:scrollView];
    self.scrollView = scrollView;

//    // 2.添加图片到scrollView中
//    for (int i = 0; i < PhotoCount; i++) {
//        UIImageView *imageView = [[UIImageView alloc] init];
//        NSString *name = [NSString stringWithFormat:@"new_feature_%d", i + 1];
//        imageView.image = [UIImage imageNamed:name];
//        [self.scrollView addSubview:imageView];
//    }
    
    // 3.设置scrollView的其他属性
    // 如果想要某个方向上不能滚动，那么这个方向对应的尺寸数值传0即可
    scrollView.bounces = NO; // 去除弹簧效果
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.delegate = self;
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    // 设置scrollView的frame
    self.scrollView.frame = self.pptView.bounds;
    
    // 设置imageView的frame
    CGFloat scrollW = self.scrollView.width;
    CGFloat scrollH = self.scrollView.height;
    for (int i = 0; i<PhotoCount; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.width = scrollW;
        imageView.height = scrollH;
        imageView.y = 0;
        imageView.x = i * scrollW;
        // 显示图片
        NSString *name = [NSString stringWithFormat:@"new_feature_%d", i + 1];
        imageView.image = [UIImage imageNamed:name];
        [self.scrollView addSubview:imageView];
    }
    
    
    self.scrollView.contentSize = CGSizeMake(PhotoCount * scrollW, 0);
}


@end
