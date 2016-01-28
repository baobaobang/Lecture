//
//  XXQuestionFrame.m
//  Lecture
//
//  Created by 陈旭 on 16/1/22.
//  Copyright © 2016年 陈旭. All rights reserved.
//

#import "XXQuestionFrame.h"
#import "XXQuestionPhotosView.h"

@implementation XXQuestionFrame

- (void)setQuestion:(XXQuestion *)question{
    _question = question;
    
    XXUser *user = question.user;
    
    // cell的宽度
    CGFloat cellW = [UIScreen mainScreen].bounds.size.width;

    /** 头像 */
    CGFloat iconWH = 44;
    CGFloat iconX = XXQuestionCellBorderW;
    CGFloat iconY = XXQuestionCellBorderW;
    self.iconViewF = CGRectMake(iconX, iconY, iconWH, iconWH);
    
    /** 昵称 */
    CGFloat nameX = CGRectGetMaxX(self.iconViewF) + XXQuestionCellBorderW;
    CGFloat nameY = iconY;
    CGSize nameSize = [user.name sizeWithFont:XXQuestionCellNameFont];
    self.nameLabelF = (CGRect){{nameX, nameY}, nameSize};
    
    /** vip会员图标 */
    if (user.isVip) {
        CGFloat vipX = CGRectGetMaxX(self.nameLabelF) + XXQuestionCellBorderW;
        CGFloat vipY = nameY + 3;
        CGFloat vipH = 15;
        CGFloat vipW = 20;
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
        CGFloat photosX = nameX;
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
    CGFloat toolbarW = maxW;
    CGFloat toolbarH = 35;
    self.toolbarF = CGRectMake(toolbarX, toolbarY, toolbarW, toolbarH);
    
    /** 回复 */
    CGFloat replyX = nameX;
    CGFloat replyY = CGRectGetMaxY(self.toolbarF);
    CGFloat replyW = maxW;
    CGFloat replyH = question.replys.count * kXXQuestionReplyCellHeight;
    self.replyF = CGRectMake(replyX, replyY, replyW, replyH);
    
    /* cell的高度 */
    if (question.replys.count) { // 有回复
        self.cellHeight = CGRectGetMaxY(self.replyF);
    }else{
        self.cellHeight = CGRectGetMaxY(self.toolbarF);
    }
    
}

- (NSComparisonResult)compareAttitudesCount:(XXQuestionFrame *)other{
    
    if (self.question.attitudes_count > other.question.attitudes_count) {
        return NSOrderedAscending;
    }else if(self.question.attitudes_count < other.question.attitudes_count){
        return NSOrderedDescending;
    }else{
        return NSOrderedSame;
    }
}
@end
