//
//  XXXRegisterVC.m
//  lecture
//
//  Created by mortal on 16/1/20.
//  Copyright © 2016年 禾医健康科技. All rights reserved.
//

#import "XXXRegisterVC.h"

@interface XXXRegisterVC()

@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;
@property (nonatomic, strong) dispatch_source_t timer;
@end

@implementation XXXRegisterVC

- (void)viewDidLoad{
    [super viewDidLoad];
    
}



//获取验证码
- (IBAction)getCode:(UIButton *)sender {
    sender.backgroundColor = RGB(237, 200, 200);
    sender.enabled = NO;
    __block int timeCount = 60;
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    dispatch_source_set_timer(_timer, DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(_timer, ^{
        if (timeCount <= 0) {
            //倒计时结束
            dispatch_source_cancel(_timer);
            [sender setTitle:@"获取验证码" forState:0];
            sender.backgroundColor = [UIColor colorWithRed:66/255.0 green:179/255.0 blue:227/255.0 alpha:1];
            sender.enabled = YES;
            return;
        }
        
        [sender setTitle:[NSString stringWithFormat:@"%ds",timeCount] forState:0];
        
        timeCount --;
    });

    dispatch_resume(_timer);
}


//完成
- (IBAction)finish:(UIButton *)sender {
    
}

@end
