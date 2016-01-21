//
//  XXPlayerPicView.h
//  Lecture
//
//  Created by 陈旭 on 16/1/20.
//  Copyright © 2016年 陈旭. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXPlayerPicView.h"
#import "XXPlayerMaskView.h"
@class XXPlayerPicView;

@protocol XXPlayerPicViewDelegate <NSObject>

@optional

- (void)playerPicView:(XXPlayerPicView *)playerPicView didClickCollectionView:(UICollectionView *)collectionView;
- (void)playerPicView:(XXPlayerPicView *)playerPicView didClickPlayerMaskView:(XXPlayerMaskView *)maskView;
- (void)playerPicView:(XXPlayerPicView *)playerPicView collectionViewDidEndDecelerating:(UICollectionView *)collectionView;

@end

@interface XXPlayerPicView : UIView

@property (nonatomic, weak) UICollectionView *collectionView;
@property (nonatomic, weak) XXPlayerMaskView *maskView;

/** 音乐数据 */
@property(strong,nonatomic) NSArray *musics;

@property (nonatomic, weak) id<XXPlayerPicViewDelegate> delegate;
@end
