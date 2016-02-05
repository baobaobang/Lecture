//
//  XXOnlineHeaderView.m
//  Lecture
//
//  Created by 陈旭 on 16/1/26.
//  Copyright © 2016年 陈旭. All rights reserved.
//

#import "XXOnlineHeaderView.h"
#import "XXContractButton.h"

@interface XXOnlineHeaderView ()
@property (weak, nonatomic) IBOutlet XXContractButton *contractBtn;

@end

@implementation XXOnlineHeaderView

- (void)awakeFromNib{
    [super awakeFromNib];

}

/**
 *  收起和展开picView和专家简介部分
 */
- (IBAction)showAndHidePicView:(UIButton *)btn {
    
    if ([self.delegate respondsToSelector:@selector(onlineHeaderView:didClickContractBtn:)]) {
        [self.delegate onlineHeaderView:self didClickContractBtn:btn];
    }
    
    btn.selected = !btn.selected;
}

@end
