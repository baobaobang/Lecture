//
//  XXQuestionPhotoCollectionViewCell.m
//  Lecture
//
//  Created by 陈旭 on 16/1/24.
//  Copyright © 2016年 陈旭. All rights reserved.
//

//  增强：带有占位文字

#import "XXQuestionPhotoCollectionViewCell.h"

@implementation XXQuestionPhotoCollectionViewCell

-(ZLCameraImageView *)photoImageView{
    if(_photoImageView==nil){
        _photoImageView=[[ZLCameraImageView alloc] initWithFrame:self.bounds];
        _photoImageView.contentMode=UIViewContentModeScaleAspectFill;
        _photoImageView.layer.masksToBounds=YES;
    }
    return _photoImageView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.photoImageView];
    }
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];    
    self.photoImageView.image = nil;
    self.indexPath = nil;
}

@end
