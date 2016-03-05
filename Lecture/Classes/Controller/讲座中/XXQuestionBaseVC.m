//
//  XXQuestionBaseVC.m
//  Lecture
//
//  Created by 陈旭 on 16/1/29.
//  Copyright © 2016年 陈旭. All rights reserved.
//

#import "XXQuestionBaseVC.h"
#import "XXQuestionCell.h"
#import "XXQuestionToolbar.h"
#import "CXTextView.h"
#import "XXReply.h"
#import "XXReplyPlayingIndex.h"
#import "XXExpertReplyView.h"
#import "HMAudioTool.h"
#import "AudioTool.h"
#import "Transcoder.h"

@interface XXQuestionBaseVC ()<XXQuestionToolbarDelegate, UITextViewDelegate, XXExpertReplyViewDelegate, AVAudioPlayerDelegate>
@property (nonatomic, strong) UIImageView *noDataImage;
@property (nonatomic, copy) NSString *replyingQuestionId;
@property (nonatomic, assign) NSInteger replyingQuestionIndex;

@property (nonatomic, strong) XXReplyPlayingIndex *clickedIndex; // 正在播放的回复index

// 录音部分
@property (nonatomic, strong) NSURL *fileUrl;
@property (nonatomic, copy) NSString *path;
@property (nonatomic, copy) NSString *mp3Path;
@property (nonatomic, weak) AVAudioRecorder *recorder;
@property (nonatomic, weak) AVAudioPlayer *player;
@property (nonatomic, weak) XXExpertReplyView *replyView;

@end

@implementation XXQuestionBaseVC

- (NSMutableArray *)questionFrames
{
    if (!_questionFrames) {
        
        _questionFrames = [[NSMutableArray alloc] init];
    }
    return _questionFrames;
}

/**
 *  将XXQuestion模型转为XXQuestionFrame模型
 */
- (NSMutableArray *)questionFramesWithQuestions:(NSMutableArray *)questions
{
    NSMutableArray *frames = [NSMutableArray array];
    for (XXQuestion *question in questions) {
        XXQuestionFrame *f = [[XXQuestionFrame alloc] init];
        f.question = question;
        [frames addObject:f];
    }
    return frames;
}

#pragma mark - 生命周期
- (void)dealloc
{
    //    XXLog(@"%@",self.textView);
    [XXNotificationCenter removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 注册cell
    [self.tableView registerClass:[XXQuestionCell class] forCellReuseIdentifier:XXQuestionCellReuseId];
    
    // 回复部分
    if (!isExpert) { // 如果是用户，则设置输入框
        [self setupTextView];
    }
    
    [self setupRefresh];
    
//    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
//    self.tableView.tag = 1;
    
    // 点击回复音频按钮收到的通知
    [XXNotificationCenter addObserver:self selector:@selector(clickReplyAudio:) name:XXReplyCellPlayBtnDidClickNotification object:nil];
    
    self.clickedIndex = nil;
}


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [XXNotificationCenter addObserver:self selector:@selector(clickReplyCell:) name:XXReplyCellDidClickNotification object:nil];
    
    // 键盘的frame发生改变时发出的通知（位置和尺寸）
    [XXNotificationCenter addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [XXNotificationCenter addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self.textView resignFirstResponder];
    
    [XXNotificationCenter removeObserver:self];
}

#pragma mark - 初始化方法
- (void)setupTextView{
    CXTextView *textView = [[CXTextView alloc] init];
    textView.font = [UIFont systemFontOfSize:kXXTextFont];
    textView.frame = CGRectMake(0, XXScreenHeight, XXScreenWidth, kXXQuestionVCTextViewOriginalHeight); // 初始位置为底部
    textView.delegate = self;
    textView.returnKeyType = UIReturnKeySend; // 设置“发送”按钮
    textView.enablesReturnKeyAutomatically = YES;//这里设置为无文字就灰色不可点
    textView.placeholder = @"回复";// 占位文字
    textView.autoAdjust = YES; // 自适应
    textView.adjustTop = YES; // 向上调整
    textView.maxHeight = kXXQuestionVCTextViewMaxHeight; // 最大高度限制
    [textView setupBorderolor:XXColor(200, 200, 200) borderWidth:1 cornerRadius:5 masksToBounds:YES];// 设置边框
    
    [XXKeyWindow addSubview:textView]; // 添加到窗口上，这样不会跟着tableview一起滚动
    self.textView = textView;
}

- (void)setupRefresh{
    WS(weakSelf);
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf headerRefreshAction];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf footerRefreshAction];
    }];
    //    self.tableView.mj_header.hidden = YES;
    //    self.tableView.mj_footer.hidden = YES;
    [self.tableView.mj_header beginRefreshing];
}
#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.questionFrames.count == 0) {
        self.noDataImage.layer.opacity = 1;
    }else{
        self.noDataImage.layer.opacity = 0;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.questionFrames.count;
}

// cell创建和数据
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    XXQuestionCell *questionCell = [[XXQuestionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:XXQuestionCellReuseId];
    
    // 设置toolBar的代理
    questionCell.toolbar.delegate = self;
    
    // 给cell的子控件赋值
    questionCell.questionFrame = self.questionFrames[indexPath.row];
    questionCell.indexPath = indexPath;
    questionCell.clickedIndex = self.clickedIndex;
    
    return questionCell;
}

#pragma mark - cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XXQuestionFrame *frame = self.questionFrames[indexPath.row];
    return frame.cellHeight;
}

#pragma mark - 点击cell后的反应
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.textView resignFirstResponder];
}

#pragma mark - 点击toolbar上的按钮，XXQuestionToolbarDelegate
- (void)questionToolbar:(XXQuestionToolbar *)toolbar didClickBtnType:(XXQuestionToolbarButtonType)type{
    switch (type) {
        case XXQuestionToolbarButtonTypeShare:{
            [self clickShareBtnInToolbar:toolbar];
            break;
        }
        case XXQuestionToolbarButtonTypeReply:{
            [self clickReplyBtnInToolbar:toolbar];
            break;
        }
        case XXQuestionToolbarButtonTypeUnlike:{
            [self clickUnlikeBtnInToolbar:toolbar];
            break;
        }
            
        default:
            break;
    }
}

#pragma mark - 根据toolbar获得question的id
- (NSString *)questionId:(XXQuestionToolbar *)toolbar{
    // 找到所点击的cell和问题id
    XXQuestionCell *cell = (XXQuestionCell *)toolbar.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    self.replyingQuestionIndex = indexPath.row;
    XXQuestionFrame *frame = self.questionFrames[indexPath.row];
    return frame.question.ID;
}

//#pragma mark - 点击分享按钮后，以后做
- (void)clickShareBtnInToolbar:(XXQuestionToolbar *)toolbar
{

}

#pragma mark - 点击回复按钮后，开始回复
- (void)clickReplyBtnInToolbar:(XXQuestionToolbar *)toolbar
{
    [self beginReplyWithQuestionId:[self questionId:toolbar]];
}

#pragma mark - 点击回复cell后，开始回复
- (void)clickReplyCell:(NSNotification *)noti
{
    [self beginReplyWithQuestionId:noti.userInfo[@"questionId"]];
}


#pragma mark - 开始回复
- (void)beginReplyWithQuestionId:(NSString *)questionId{
    if (isExpert) { // 专家情况
        XXExpertReplyView *replyView = [[[NSBundle mainBundle] loadNibNamed:@"XXExpertReplyView" owner:nil options:nil] lastObject];
        replyView.frame = CGRectMake(0, 0, XXScreenWidth, XXScreenHeight);
        [XXTopWindow addSubview:replyView];
        replyView.delegate = self;
        self.replyingQuestionId = questionId;
        self.replyView = replyView;
    }else{ // 用户情况
        if (![self.textView isFirstResponder]) {
            [self.textView becomeFirstResponder]; // 懒加载textview，并唤起键盘
        }
        if (![questionId isEqualToString:self.replyingQuestionId]) { // 如果回复的是不同的问题，就清空之前的回复
            self.textView.text = nil;
            self.replyingQuestionId = questionId;
        }
    }
    
}

#pragma mark - XXExpertReplyViewDelegate 专家录音部分

// 点击取消按钮
- (void)expertReplyView:(XXExpertReplyView *)expertReplyView didClickCancleButton:(UIButton *)btn{
    [self.recorder deleteRecording];
    [expertReplyView removeFromSuperview];
}

// 点击发送按钮
- (void)expertReplyView:(XXExpertReplyView *)expertReplyView didClickSendButton:(UIButton *)btn{
    [self sendReply];
}

// 点击topView
- (void)expertReplyView:(XXExpertReplyView *)expertReplyView didClickTopView:(UIView *)view{
    if (expertReplyView.status == XXExpertReplyButtonStatusInitial) {
        [expertReplyView removeFromSuperview];
    }
}

// 点击中间按钮
- (void)expertReplyView:(XXExpertReplyView *)expertReplyView didClickMiddleButton:(UIButton *)btn{
    switch (expertReplyView.status) {
        case XXExpertReplyButtonStatusInitial:// 开始录音
        {
            NSString * document = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
            NSString *voiceName = [NSString stringWithFormat:@"lecture%@question%@%@",self.lecture.lectureId, self.replyingQuestionId, @".wav"];
            NSString *path = [document stringByAppendingPathComponent:voiceName];
            self.path = path;
            self.fileUrl = [NSURL URLWithString:path];
            AVAudioRecorder *recorder = [[AudioTool shareAudioTool] recorderWithURL:self.fileUrl];
            self.recorder = recorder;
            expertReplyView.recorder = recorder;
            
            if ([recorder prepareToRecord]) {
                [recorder record];
                expertReplyView.status = XXExpertReplyButtonStatusRecording;
            }
        }
            break;
        case XXExpertReplyButtonStatusRecording:// 结束录音
        {
            [self.recorder stop];
            AVAudioPlayer *player = [[AudioTool shareAudioTool] playerWithURL:self.fileUrl];
            self.player = player;
            player.delegate = self;
            expertReplyView.player = player;
            expertReplyView.status = XXExpertReplyButtonStatusStop;
            break;
        }
        case XXExpertReplyButtonStatusStop:// 开始播放
        {
            if ([self.player prepareToPlay]) {
                [self.player play];
            };
            expertReplyView.status = XXExpertReplyButtonStatusPlaying;
            break;
        }
        case XXExpertReplyButtonStatusPlaying:// 结束播放
        {
            [self.player stop];
            self.player.currentTime = 0;
            expertReplyView.status = XXExpertReplyButtonStatusStop;
            break;
        }
        default:
            break;
    }
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    self.replyView.status = XXExpertReplyButtonStatusStop;
}

#pragma mark - 发送回复接口
- (void)sendReply{
    if (isExpert) {
        [self uploadExpertReplyMp3];
        [self.replyView removeFromSuperview];
    }else{
        [self postReplyWithContent:self.textView.text questionId:self.replyingQuestionId];
        [self.textView resignFirstResponder];
    }
}

// 上传专家回复音频
- (void)uploadExpertReplyMp3{
    // wav转MP3
    NSString *mp3Path = [[self.path stringByDeletingPathExtension] stringByAppendingPathExtension:@"mp3"];
    [Transcoder transcodeToMP3From:self.path toPath:mp3Path];
    // MP3转二进制
    NSData *data = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:mp3Path]];
    
    // 陈旭接口-上传专家回复音频
    [NetworkManager qiniuUpload:data progress:^(NSString *key, float percent) {
        
        [SVProgressHUD showProgress:percent];
    } success:^(id result) {// 音频上传成功
        [SVProgressHUD dismiss];
        // 移除本地mp3
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager removeItemAtPath:mp3Path error:nil];
        // 上传音频路径到服务器
        [self postReplyWithContent:result questionId:self.replyingQuestionId];
    } fail:^(NSError *error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:@"发送失败"];
        // 移除本地mp3
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager removeItemAtPath:mp3Path error:nil];
    } isImageType:NO];
}

// 上传回复文本
- (void)postReplyWithContent:(NSString *)content questionId:(NSString *)questionId{
    // 陈旭接口-发送回复接口
    NSString *url = [NSString stringWithFormat:@"questions/%@/replies", questionId];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"content"] = content;
    params[@"type"] = isExpert ? @"1" : @"0";
    WS(weakSelf);
    [NetworkManager postWithApi:url params:params success:^(id result) {
        // 插入新增回复(以后用本地离线缓存来做插入)
        //        XXQuestionFrame *frame = weakSelf.questionFrames[weakSelf.replyingQuestionIndex];
        XXReply *reply = [[XXReply alloc] init];
        
        reply.questionId = questionId;
        reply.nickName = @"匿名用户"; // 当前用户的昵称
        reply.content = content;
        reply.type = isExpert ? 1 : 0;
        
        NSUInteger count = weakSelf.questionFrames.count;
        NSMutableArray *questionsM = [NSMutableArray array];
        for (NSInteger i = 0; i < count; i++) {
            XXQuestionFrame * frame = weakSelf.questionFrames[i];
            XXQuestion *question = frame.question;
            if (i == weakSelf.replyingQuestionIndex) {
                [question.replies addObject:reply];
            }
            [questionsM addObject:question];
        }
        
        weakSelf.questionFrames = [weakSelf questionFramesWithQuestions:questionsM];
        
        // 刷新当前问题行
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:weakSelf.replyingQuestionIndex inSection:0];
        [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        // 滚动到所在问题行的底部
        [weakSelf.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        
        // 清空文字
        if (!isExpert) {
            weakSelf.textView.text = nil;
        }
        
    } fail:^(NSError *error) {
        [MBProgressHUD showError:@"发送失败！" toView:weakSelf.view];
    }];
}



#pragma mark - 点击点赞按钮后
- (void)clickUnlikeBtnInToolbar:(XXQuestionToolbar *)toolbar
{
    // 陈旭接口-点赞接口
    //FIXME: 何老师，点赞接口是不是要加入lecture的id
    WS(weakSelf);
    NSString *url = [NSString stringWithFormat:@"questions/%@/likers", [self questionId:toolbar]];
    [NetworkManager postWithApi:url params:nil success:^(id result) {
        
    } fail:^(NSError *error) {

    }];
}

#pragma mark - 键盘的frame发生改变时调用（显示、隐藏等）

- (void)keyboardWillShow:(NSNotification *)notification{
    NSDictionary *userInfo = notification.userInfo;
    // 动画的持续时间（和键盘的动画时间要一致）
    double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    // 键盘的frame
    CGRect keyboardF = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    // {{0, 344}, {320, 224}}

    // 执行动画
    WS(weakSelf);
    [UIView animateWithDuration:duration animations:^{
        // textview的Y值 == 键盘的Y值 - textview的高度
        weakSelf.textView.y = keyboardF.origin.y  - weakSelf.textView.height;
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification{
    NSDictionary *userInfo = notification.userInfo;
    // 动画的持续时间（和键盘的动画时间要一致）
    double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    // 键盘的frame
    CGRect keyboardF = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    // {{0, 568}, {320, 224}}

    // 执行动画
    WS(weakSelf);
    [UIView animateWithDuration:duration animations:^{
        // textview的Y值 == 键盘的Y值
        weakSelf.textView.y = keyboardF.origin.y;
    }];
}


#pragma mark - UITextViewDelegate

// 这个函数的最后一个参数text代表你每次输入的的那个字
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    // 限制字数
    if ([text isEqualToString:@""]) {//这个是汉语联想的时候的他会出现的，第一次暂时让其联想，下次输入就不能联想了，因为第一次联想它不给自己算lenth，下次再联想词汇就会算上上次输入的，这个是苹果自己的BUG 如果是textfiled，一样 检测每个字符的变化。
        return YES;
    }
    if (textView.text.length>=kXXQuestionVCTextViewMaxWords)
    {
        // 给个提示
        NSString *message = [NSString stringWithFormat:@"字符个数不能大于%lu！", (unsigned long)kXXQuestionVCTextViewMaxWords];
        UIAlertView *tipAlert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [tipAlert show];
        return NO;
    }
    
    // 监听文字输入，来完成发送
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        [self sendReply];
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    
    // 禁用emoji字符并提示
    return [text forbiddenEmoji];
}


#pragma mark - scrollView Delegate
// 拖动tableview就退出键盘
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if ([scrollView isKindOfClass:[UITableView class]]) {
        [self.textView resignFirstResponder];
    }
}

#pragma mark - 刷新

- (void)headerRefreshAction{
    //    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //        [self endHeaderRefresh];
    //    });
}
- (void)footerRefreshAction{
    //    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //        [self endFooterRefresh];
    //    });
}

- (void)endHeaderRefresh{
    [self.tableView.mj_header endRefreshing];
}

- (void)endFooterRefresh{
    [self.tableView.mj_footer endRefreshing];
}

#pragma mark - 无数据时候显示的图片
- (UIImageView *)noDataImage{
    if (!_noDataImage) {
        _noDataImage = [[UIImageView alloc]initWithFrame:CGRectMake(SWIDTH/2-50, SHEIGHT/2-150, 100, 150)];
        _noDataImage.image = [UIImage imageNamed:@"nodata"];
        [self.tableView addSubview:_noDataImage];
    }
    return _noDataImage;
}
#pragma mark - 点击回复音频后，传递值给tableview
- (void)clickReplyAudio:(NSNotification *)noti
{
    self.clickedIndex = noti.userInfo[@"index"];
}

@end
