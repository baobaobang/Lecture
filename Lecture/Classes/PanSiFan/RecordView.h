//
//  RecordView.h
//  Upload
//
//  Created by mortal on 16/1/12.
//  Copyright © 2016年 禾医健康科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RecordViewDelegate <NSObject>

- (void)deleteAtIndex:(NSInteger)tag;

@end

@interface RecordView : UIView

@property (nonatomic, weak) id<RecordViewDelegate> delegate;
+ (RecordView *)viewWithUrl:(NSString *)url index:(NSInteger)index name:(NSString *)name;

@end
