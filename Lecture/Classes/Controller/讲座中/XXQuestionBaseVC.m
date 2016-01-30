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

@interface XXQuestionBaseVC ()<XXQuestionToolbarDelegate, UITextViewDelegate>

@end

@implementation XXQuestionBaseVC

- (NSArray *)questionFrames
{
    if (!_questionFrames) {
        
        _questionFrames = [[NSArray alloc] init];
    }
    return _questionFrames;
}

/**
 *  将XXQuestion模型转为XXQuestionFrame模型
 */
- (NSArray *)questionFramesWithQuestions:(NSArray *)questions
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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 注册cell
    [self.tableView registerClass:[XXQuestionCell class] forCellReuseIdentifier:XXQuestionCellReuseId];
    
    //
    [self setupTextView];
}

- (void)dealloc
{
    NSLog(@"%@",self.textView);
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
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
    textView.backgroundColor = XXTestColor;
    textView.frame = CGRectMake(0, XXScreenHeight, XXScreenWidth, kXXQuestionVCTextViewOriginalHeight); // 初始位置为底部
    textView.delegate = self;
    textView.returnKeyType = UIReturnKeySend; // 设置“发送”按钮
    textView.enablesReturnKeyAutomatically = YES;//这里设置为无文字就灰色不可点
    textView.placeholder = @"回复";// 占位文字
    textView.autoAdjust = YES; // 自适应
    textView.adjustTop = YES; // 向上调整
    textView.maxHeight = kXXQuestionVCTextViewMaxHeight; // 最大高度限制
    [XXKeyWindow addSubview:textView]; // 添加到窗口上，这样不会跟着tableview一起滚动
    self.textView = textView;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
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
#pragma mark - 点击分享后
- (void)clickShareBtnInToolbar:(XXQuestionToolbar *)toolbar
{
    //TODO: 弹出分享窗口
}
#pragma mark - 点击回复后
- (void)clickReplyBtnInToolbar:(XXQuestionToolbar *)toolbar
{
    [self.textView becomeFirstResponder]; // 懒加载textview，并唤起键盘
    
    //让所点击的cell的底部滚动到输入框的正上方
    NSUInteger row = [self.questionFrames indexOfObject:toolbar.questionFrame];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

#pragma mark - 点击点赞后
- (void)clickUnlikeBtnInToolbar:(XXQuestionToolbar *)toolbar
{
    NSUInteger oldRow = [self.questionFrames indexOfObject:toolbar.questionFrame];
    NSIndexPath *oldIndexPath = [NSIndexPath indexPathForRow:oldRow inSection:0];
    // 将question数组按照点赞数来排序，再刷新表格和cell顺序
    self.questionFrames = [self.questionFrames sortedArrayUsingSelector:@selector(compareAttitudesCount:)];
    NSUInteger newRow = [self.questionFrames indexOfObject:toolbar.questionFrame];
    NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:newRow inSection:0];
    
    // 动画交换两个cell的顺序
    [self.tableView moveRowAtIndexPath:oldIndexPath toIndexPath:newIndexPath];
    // 滚动到点赞所在cell的位置
    [self.tableView scrollToRowAtIndexPath:newIndexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    
}

#pragma mark - 键盘的frame发生改变时调用（显示、隐藏等）

- (void)keyboardWillShow:(NSNotification *)notification{
    NSDictionary *userInfo = notification.userInfo;
    // 动画的持续时间（和键盘的动画时间要一致）
    double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    // 键盘的frame
    CGRect keyboardF = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    // {{0, 344}, {320, 224}}
    //    NSLog(@"keyboardWillShow--%@", NSStringFromCGRect(keyboardF));
    // 执行动画
    [UIView animateWithDuration:duration animations:^{
        // textview的Y值 == 键盘的Y值 - textview的高度
        self.textView.y = keyboardF.origin.y  - self.textView.height;
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification{
    NSDictionary *userInfo = notification.userInfo;
    // 动画的持续时间（和键盘的动画时间要一致）
    double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    // 键盘的frame
    CGRect keyboardF = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    // {{0, 568}, {320, 224}}
    //    NSLog(@"keyboardWillHide--%@", NSStringFromCGRect(keyboardF));
    // 执行动画
    [UIView animateWithDuration:duration animations:^{
        // textview的Y值 == 键盘的Y值
        self.textView.y = keyboardF.origin.y;
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
        NSString *message = [NSString stringWithFormat:@"字符个数不能大于%lu！", kXXQuestionVCTextViewMaxWords];
        UIAlertView *tipAlert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [tipAlert show];
        return NO;
    }
    
    // 监听文字输入，来完成发送
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        [self send];
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    
    return YES;
}

- (void)send{
    //TODO: 记录text并显示出来
    XXLog(@"send");
    [self.textView resignFirstResponder];
}

@end
