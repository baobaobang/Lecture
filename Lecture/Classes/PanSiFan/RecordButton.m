//
//  RecordButton.m
//  Upload
//
//  Created by mortal on 16/1/13.
//  Copyright © 2016年 禾医健康科技. All rights reserved.
//

#import "RecordButton.h"

@implementation RecordButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor redColor];
        self.layer.cornerRadius = frame.size.height/2;
        self.deleteBtn = [[UIButton alloc]initWithFrame:CGRectMake(2.5, 2.5, frame.size.height-5,  frame.size.height-5)];
        [self.deleteBtn setBackgroundImage:[UIImage imageNamed:@"delete-button"] forState:0];
        [self.deleteBtn addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.deleteBtn];
        CGFloat H = frame.size.height;
        CGFloat W = frame.size.width;
        self.timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(W-50, 0, 55,H )];
        [self.timeLabel setTextColor:[UIColor whiteColor]];
        self.timeLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:self.timeLabel];
        
        UIImageView *wave = [[UIImageView alloc]initWithFrame:CGRectMake(H, 0, 100, H)];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(save)];
        [self addGestureRecognizer:tap];
        wave.image = [UIImage imageNamed:@"wave"];
        [self addSubview:wave];
    }
    return self;
}

- (void)save {
    [self.delegate stopRecord:self];
}
@end
