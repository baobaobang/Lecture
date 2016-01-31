//
//  XXCollectionViewFlowLayout.m
//  Lecture
//
//  Created by 陈旭 on 16/1/31.
//  Copyright © 2016年 陈旭. All rights reserved.
//

#import "XXCollectionViewFlowLayout.h"

@implementation XXCollectionViewFlowLayout
// 什么时候调用:每次collectionView布局都会调用这个方法,每次collectionView刷新数据也会调用
// 一般情况下,只会调用一次
// 作用:计算所有cell的尺寸,前提条件,cell的位置固定的时候才在这计算.
// 注意:必须要调用[super prepareLayout]
- (void)prepareLayout
{
    [super prepareLayout];
    
    [self setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    self.minimumInteritemSpacing = 0;
    self.minimumLineSpacing = 0; //上下的间距
    self.sectionInset = UIEdgeInsetsZero;
    self.footerReferenceSize = CGSizeZero;
    self.headerReferenceSize = CGSizeZero;
    
    self.itemSize = self.collectionView.size;// 计算所有cell的尺寸
}

// 是否允许当滚动屏幕刷新布局
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

@end
