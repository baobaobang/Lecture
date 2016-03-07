//
//  CXCircularProgressView.h
//  Lecture
//
//  Created by 陈旭 on 16/3/5.
//  Copyright © 2016年 陈旭. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface CXCircularProgressView : UIView

@property (nonatomic) UIColor *backColor;
@property (nonatomic) UIColor *progressColor;
@property (nonatomic) CGFloat lineWidth;

- (id)initWithFrame:(CGRect)frame
          backColor:(UIColor *)backColor
      progressColor:(UIColor *)progressColor
          lineWidth:(CGFloat)lineWidth
            player:(AVAudioPlayer *)player;

- (void)play;
- (void)stop;
@end
