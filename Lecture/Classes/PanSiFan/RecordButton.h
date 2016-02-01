//
//  RecordButton.h
//  Upload
//
//  Created by mortal on 16/1/13.
//  Copyright © 2016年 禾医健康科技. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RecordButton;
@protocol RecordStopDelegate <NSObject>

- (void)stopRecord:(RecordButton *) button;

@end

@interface RecordButton : UIView

@property (nonatomic, strong) UIButton *deleteBtn;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, weak) id<RecordStopDelegate> delegate;
@end

