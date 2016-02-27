//
//  XXXBaseScrollVC.m
//  Lecture
//
//  Created by mortal on 16/2/3.
//  Copyright © 2016年 陈旭. All rights reserved.
//

#import "XXXBaseScrollVC.h"

@implementation XXXBaseScrollVC


- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doKeyBoardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doKeyBoardHide:) name:UIKeyboardWillHideNotification object:nil];
}


# pragma textField代理

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    self.curTextField = textField;
    return YES;
}

/**
 *  键盘呼出处理
 *
 *  @param nottification 通知
 */
- (void)doKeyBoardShow:(NSNotification *)nottification {
//    NSLog(@"%f",self.scrollView.contentSize.height);
    
    CGRect keyBoardFrame = [nottification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, keyBoardFrame.size.height, 0);
    [self.scrollView scrollRectToVisible:self.curTextField.frame animated:YES];
    
}

/**
 *  键盘隐藏处理
 *
 *  @param nottification 通知
 */
- (void)doKeyBoardHide:(NSNotification *)nottification {
    
    self.scrollView.contentInset = UIEdgeInsetsZero;
}

- (void)dealloc{
    //移除监听
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
