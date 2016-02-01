//
//  TipView.m
//  Upload
//
//  Created by mortal on 16/1/20.
//  Copyright © 2016年 禾医健康科技. All rights reserved.
//

#import "TipView.h"

@implementation TipView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundImage:[UIImage imageNamed:@"title"] forState:0];
        [self setBackgroundImage:[UIImage imageNamed:@"title_normal"] forState:UIControlStateSelected];
//        UIButton *close = [[UIButton alloc]initWithFrame:CGRectMake(frame.size.width-frame.size.height, 0, frame.size.height, frame.size.height)];
//        [close setBackgroundImage:[UIImage imageNamed:@"round"] forState:0];
//        [close addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:close];
        
        [self addTarget:self action:@selector(clicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)close{
    [self.delegate tipView:self closeIndex:self.tag];
}

- (void)clicked{
    [self.delegate tipView:self clickAtIndex:self.tag];
    self.selected = YES;
}
@end
