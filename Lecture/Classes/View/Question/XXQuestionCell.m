//
//  XXQuestionCell.m
//  Lecture
//
//  Created by 陈旭 on 16/1/10.
//  Copyright © 2016年 陈旭. All rights reserved.
//

#import "XXQuestionCell.h"
#import "XXQuestionToolbar.h"
#import "XXQuestion.h"
#import "XXQuestionPhotosView.h"
#import "XXQuestionFrame.h"
#import "UIButton+WebCache.h"
#import "XXQuestionReplyView.h"

@interface XXQuestionCell ()

/** 头像 */
@property (nonatomic, weak) UIButton *iconView;
/** 昵称 */
@property (nonatomic, weak) UILabel *nameLabel;
/** 会员图标 */
//@property (nonatomic, weak) UIImageView *vipView;
/** 正文 */
@property (nonatomic, weak) UILabel *contentLabel;
/** 配图 */
@property (nonatomic, weak) XXQuestionPhotosView *photosView;
/** 回复 */
@property (nonatomic, weak) XXQuestionReplyView *replyView;

@end
@implementation XXQuestionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = [UIColor clearColor];
        // 设置cell选中时不变色
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        // 初始化
        [self setup];
    }
    return self;
}

/**
 * 初始化
 */
- (void)setup
{
    
    /** 头像 */
    UIButton *iconView = [[UIButton alloc] init];
    iconView.adjustsImageWhenHighlighted = NO;
    [self.contentView addSubview:iconView];
    self.iconView = iconView;
    
    /** 昵称 */
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.font = XXQuestionCellNameFont;
    [self.contentView addSubview:nameLabel];
    self.nameLabel = nameLabel;
    
    /** 会员图标 */
//    UIImageView *vipView = [[UIImageView alloc] init];
//    vipView.contentMode = UIViewContentModeScaleAspectFill;
//    [self.contentView addSubview:vipView];
//    self.vipView = vipView;
    
    /** 正文 */
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.font = XXQuestionCellContentFont;
    contentLabel.numberOfLines = 0;
    [self.contentView addSubview:contentLabel];
    self.contentLabel = contentLabel;
    
    /** 配图 */
    XXQuestionPhotosView *photosView = [[XXQuestionPhotosView alloc] init];
    [self.contentView addSubview:photosView];
    self.photosView = photosView;
    
    /** 工具条 */
    XXQuestionToolbar *toolbar = [XXQuestionToolbar toolbar];
    [self.contentView addSubview:toolbar];
    self.toolbar = toolbar;
    
    /** 回复 */
    XXQuestionReplyView *replyView = [[XXQuestionReplyView alloc] init];
    [self.contentView addSubview:replyView];
    self.replyView = replyView;
}

- (void)setQuestionFrame:(XXQuestionFrame *)questionFrame
{
    _questionFrame = questionFrame;
    
    XXQuestion *question = questionFrame.question;
    XXUser *user = question.user;
    
    /** 头像 */
    self.iconView.frame = questionFrame.iconViewF;
    [self.iconView sd_setBackgroundImageWithURL:[NSURL URLWithString:user.icon] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"avatar_default_small"]];
    self.iconView.layer.cornerRadius = self.iconView.width / 2;
    self.iconView.layer.masksToBounds = YES;
    
    /** 昵称 */
    self.nameLabel.text = user.name;
    self.nameLabel.frame = questionFrame.nameLabelF;
    
    /** 会员图标 */
//    if (user.isVip) {
//        self.vipView.hidden = NO;
//        
//        self.vipView.frame = questionFrame.vipViewF;
//        NSString *vipName = [NSString stringWithFormat:@"user_vip_%@", user.vipLevel];
//        self.vipView.image = [UIImage imageNamed:vipName];
//    } else {
//        self.vipView.hidden = YES;
//    }
    
    /** 正文 */
    self.contentLabel.text = question.text;
    self.contentLabel.frame = questionFrame.contentLabelF;
    
    /** 配图 */
    if (question.pic_urls.count) {
        self.photosView.frame = questionFrame.photosViewF;
        self.photosView.photos = question.pic_urls;
        self.photosView.hidden = NO;
    } else {
        self.photosView.hidden = YES;
    }
    
    /** 工具条 */
    self.toolbar.frame = questionFrame.toolbarF;
    self.toolbar.questionFrame = questionFrame;
    
    /** 回复 */
    self.replyView.frame = questionFrame.replyF;
    self.replyView.replys = question.replys;
}

@end
