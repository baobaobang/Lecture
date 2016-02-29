//
//  XXQuestionReplyView.m
//  Lecture
//
//  Created by 陈旭 on 16/1/28.
//  Copyright © 2016年 陈旭. All rights reserved.
//

#import "XXQuestionReplyView.h"
#import "XXQuestionReplyCell.h"
#import "XXQuestionReplyUserCell.h"
#import "XXQuestionFrame.h"
#import "XXReplyPlayingIndex.h"

@interface XXQuestionReplyView ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *commentTableView;
@end

@implementation XXQuestionReplyView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.clipsToBounds=YES;
        self.backgroundColor = XXQuestionReplyBackgroundColor;
    }
    return self;
}


- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.commentTableView.frame = self.bounds;
}

- (UITableView*)commentTableView{
    if(_commentTableView==nil){
        _commentTableView= [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _commentTableView.separatorColor=[UIColor clearColor];
        _commentTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        
        [_commentTableView registerNib:[UINib nibWithNibName:@"XXQuestionReplyCell" bundle:nil] forCellReuseIdentifier:XXQuestionReplyCellReuseId];
        [_commentTableView registerNib:[UINib nibWithNibName:@"XXQuestionReplyUserCell" bundle:nil] forCellReuseIdentifier:XXQuestionReplyUserCellReuseId];
        
        _commentTableView.dataSource=self;
        _commentTableView.delegate=self;
        _commentTableView.scrollEnabled=NO;
        _commentTableView.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        _commentTableView.backgroundColor=[UIColor clearColor];
        [self addSubview:_commentTableView]; //这一步不能漏了
    }
    return _commentTableView;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.question.replies.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    XXReply *reply = self.question.replies[indexPath.row];
    if (reply.type == 0) {
        // 用户回复
        XXQuestionReplyUserCell *cell = (XXQuestionReplyUserCell *)[tableView dequeueReusableCellWithIdentifier:XXQuestionReplyUserCellReuseId forIndexPath:indexPath];
        cell.reply = reply;
        cell.tag = indexPath.row;
        return cell;
    }else{
        // 专家回复
        XXQuestionReplyCell *cell = (XXQuestionReplyCell *)[tableView dequeueReusableCellWithIdentifier:XXQuestionReplyCellReuseId forIndexPath:indexPath];
        cell.reply = reply;
        
        XXReplyPlayingIndex *index = [[XXReplyPlayingIndex alloc] init];
        index.replyIndexPath = indexPath;
        index.questionIndexPath = self.indexPath;
        cell.index = index;
        cell.clickedIndex = self.clickedIndex;
        return cell;
    }
}
#pragma mark - 计算cell高度

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    XXReply *reply = self.question.replies[indexPath.row];
    return [XXQuestionReplyView calculateCellHeightWithReply:reply];
}

+ (CGFloat)calculateCellHeightWithReply:(XXReply *)reply
{
    if(reply==nil){
        return 0;
    }
    
    NSString* text;
    if (reply.type == 0) {
        text = [reply buildCommentText];
    }else{
        text = reply.nickName;
    }
    CGSize size = [text sizeWithFont:XXQuestionCellReplyFont maxW:XXQuestionCellMaxWidth];
    return size.height + 3;//+3是为了每个cell有间距
}

#pragma mark - 计算整个view的高度
+ (CGFloat)calculateReplyViewHeightWithReplys:(NSArray *)replys{
    
    CGFloat replysHeight = 0;
    for(XXReply *reply in replys){
        replysHeight += [self calculateCellHeightWithReply:reply];
    }
    return replysHeight;
}

#pragma mark - 点击cell弹出回复textview
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [XXNotificationCenter postNotificationName:XXReplyCellDidClickNotification object:nil userInfo:@{@"questionId" : self.question.ID, @"row" : @(indexPath.row)}];
}

@end
