//
//  XXQuestionFrame.m
//  Lecture
//
//  Created by 陈旭 on 16/1/22.
//  Copyright © 2016年 陈旭. All rights reserved.
//

#import "XXQuestionFrame.h"
#import "XXQuestion.h"
#import "XXUser.h"
#import "XXQuestionPhotosView.h"

@implementation XXQuestionFrame

- (void)setQuestion:(XXQuestion *)question{
    _question = question;
    
    XXUser *user = question.user;
    
    // cell的宽度
    CGFloat cellW = [UIScreen mainScreen].bounds.size.width;

    /** 头像 */
    CGFloat iconWH = 45;
    CGFloat iconX = XXQuestionCellBorderW;
    CGFloat iconY = XXQuestionCellBorderW;
    self.iconViewF = CGRectMake(iconX, iconY, iconWH, iconWH);
    
    /** 昵称 */
    CGFloat nameX = CGRectGetMaxX(self.iconViewF) + XXQuestionCellBorderW;
    CGFloat nameY = iconY;
    CGSize nameSize = [user.name sizeWithFont:XXQuestionCellNameFont];
    self.nameLabelF = (CGRect){{nameX, nameY}, nameSize};
    
    /** 会员图标 */
    if (user.isVip) {
        CGFloat vipX = CGRectGetMaxX(self.nameLabelF) + XXQuestionCellBorderW;
        CGFloat vipY = nameY;
        CGFloat vipH = nameSize.height;
        CGFloat vipW = 30;
        self.vipViewF = CGRectMake(vipX, vipY, vipW, vipH);
    }
    
    /** 正文 */
    CGFloat contentX = nameX;
    CGFloat contentY = CGRectGetMaxY(self.nameLabelF) + XXQuestionCellBorderW;
    CGFloat maxW = cellW - contentX - XXQuestionCellBorderW;
    CGSize contentSize = [question.text sizeWithFont:XXQuestionCellContentFont maxW:maxW];
    self.contentLabelF = (CGRect){{contentX, contentY}, contentSize};
    
    /** 配图 */
    CGFloat originalH = 0;
    if (question.pic_urls.count) { // 有配图
        CGFloat photosX = contentX;
        CGFloat photosY = CGRectGetMaxY(self.contentLabelF) + XXQuestionCellBorderW;
        CGSize photosSize = [XXQuestionPhotosView sizeWithCount:question.pic_urls.count];
        self.photosViewF = (CGRect){{photosX, photosY}, photosSize};
        
        originalH = CGRectGetMaxY(self.photosViewF) + XXQuestionCellBorderW;
    } else { // 没配图
        originalH = CGRectGetMaxY(self.contentLabelF) + XXQuestionCellBorderW;
    }
  
    /** 工具条 */
    CGFloat toolbarX = nameX;
    CGFloat toolbarY = originalH;
    CGFloat toolbarW = contentSize.width;
    CGFloat toolbarH = 35;
    self.toolbarF = CGRectMake(toolbarX, toolbarY, toolbarW, toolbarH);
    
    /* cell的高度 */
    self.cellHeight = CGRectGetMaxY(self.toolbarF);
}
@end
