//
//  XXCollectionView.m
//  Lecture
//
//  Created by 陈旭 on 16/1/22.
//  Copyright © 2016年 陈旭. All rights reserved.
//

#import "XXCollectionView.h"

@implementation XXCollectionView

// 封装图片滚动的CollectionView常用属性，便于多个地方使用
- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewFlowLayout *)layout{
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        
        [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        //    layout.itemSize = self.bounds.size;// 需要在后面设置才有用
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0; //上下的间距
        layout.sectionInset = UIEdgeInsetsZero;
        layout.footerReferenceSize = CGSizeZero;
        layout.headerReferenceSize = CGSizeZero;
        
        // 其他属性
        self.collectionViewLayout = layout;
        self.pagingEnabled = YES; // 自动分页
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.bounces = NO;
    }
    return self;
}
@end
