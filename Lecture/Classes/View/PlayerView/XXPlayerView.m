//
//  XXPlayerView.m
//  Lecture
//
//  Created by 陈旭 on 16/1/7.
//  Copyright © 2016年 陈旭. All rights reserved.
//

#import "XXPlayerView.h"

@interface XXPlayerView () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *pptView;
@property (weak, nonatomic) IBOutlet UIView *playerToolBar;
@property (nonatomic, weak) UIScrollView *scrollView;
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
    self.scrollView.frame = self.pptView.bounds;
    
    // 2.添加图片到scrollView中
    CGFloat scrollW = self.scrollView.width;
    CGFloat scrollH = self.scrollView.height;
    NSUInteger photoCount = 4;
    for (int i = 0; i<photoCount; i++) {
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
    
    // 3.设置scrollView的其他属性
    // 如果想要某个方向上不能滚动，那么这个方向对应的尺寸数值传0即可
    scrollView.contentSize = CGSizeMake(photoCount * scrollW, 0);
    scrollView.bounces = NO; // 去除弹簧效果
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.delegate = self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
}


@end
