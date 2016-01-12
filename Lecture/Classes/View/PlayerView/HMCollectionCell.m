//
//  HMCollectionCell.m
//  08-无限滚动
//
//  Created by apple on 14-5-31.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "HMCollectionCell.h"
#import "HMMusic.h"

@interface HMCollectionCell()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@end

@implementation HMCollectionCell
- (void)setMusic:(HMMusic *)music
{
    _music = music;
    
    self.imageView.image = [UIImage imageNamed:music.icon];
}

@end
