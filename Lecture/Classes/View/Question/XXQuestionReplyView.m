//
//  XXQuestionReplyView.m
//  Lecture
//
//  Created by 陈旭 on 16/1/28.
//  Copyright © 2016年 陈旭. All rights reserved.
//

#import "XXQuestionReplyView.h"
#import "XXQuestionReplyCell.h"

@interface XXQuestionReplyView ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *commentTableView;
@end

@implementation XXQuestionReplyView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.clipsToBounds=YES;
        self.backgroundColor=XXColor(230, 230, 230);
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
    
    return self.replys.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XXQuestionReplyCell *cell = (XXQuestionReplyCell *)[tableView dequeueReusableCellWithIdentifier:XXQuestionReplyCellReuseId forIndexPath:indexPath];
    cell.reply = self.replys[indexPath.row];
    cell.tag = indexPath.row;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return kXXQuestionReplyCellHeight;
}

@end
