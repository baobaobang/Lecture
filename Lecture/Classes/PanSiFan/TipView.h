//
//  TipView.h
//  Upload
//
//  Created by mortal on 16/1/20.
//  Copyright © 2016年 禾医健康科技. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TipView;
@protocol TipViewDelegate <NSObject>


- (void)tipView:(TipView *)tipView clickAtIndex:(NSInteger)index;
@optional
- (void)tipView:(TipView *)tipView closeIndex:(NSInteger)index;
@end
@interface TipView : UIButton

@property (nonatomic, weak) id<TipViewDelegate> delegate;

@end
