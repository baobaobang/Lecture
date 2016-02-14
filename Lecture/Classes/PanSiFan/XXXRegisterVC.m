//
//  XXXRegisterVC.m
//  lecture
//
//  Created by mortal on 16/1/20.
//  Copyright © 2016年 禾医健康科技. All rights reserved.
//

#import "XXXRegisterVC.h"
#import "XXXProtocolTipView.h"
#import "XXXTextField.h"

@interface XXXRegisterVC()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *avatarlead;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *avatartrail;
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UIImageView *background;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backgroundH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backgroundTop;
@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;
@property (nonatomic, strong) dispatch_source_t timer;
@property (nonatomic, strong) CAShapeLayer *layer;
@property (nonatomic, strong) CADisplayLink *displayLink;
@property (weak, nonatomic) IBOutlet UIButton *checkBox;

@property (weak, nonatomic) IBOutlet XXXTextField *phone;
@property (weak, nonatomic) IBOutlet XXXTextField *code;

@end

@implementation XXXRegisterVC

- (void)viewDidLoad{
    
    [super viewDidLoad];
    self.avatarlead.constant = self.avatartrail.constant = SWIDTH/2 - self.avatar.frame.size.width/2;
    self.backgroundTop.constant = 284- 1597/980*SWIDTH;
    self.backgroundH.constant = 1597/980*SWIDTH;
    
    self.avatar.layer.borderColor = [UIColor whiteColor].CGColor;
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.fillColor = [UIColor whiteColor].CGColor;
    layer.path = [self curPath:0].CGPath;
    [self.background.layer addSublayer:layer];
    self.layer = layer;
    
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updatePath)];
    [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    
}



//获取验证码
- (IBAction)getCode:(UIButton *)sender {
    sender.backgroundColor = RGB(218, 218, 218);
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
    
    NSString *api = [NSString stringWithFormat:@"sms/%@",self.phone.text];
    [NetworkManager getWithApi:api params:nil success:^(id result) {
        
    } fail:^(NSError *error) {
        
    }];
}


//完成
- (IBAction)finish:(UIButton *)sender {
    if (self.checkBox.selected) {
        AlertMessage(@"同意注册协议才可以进行注册");
        return;
    }
    NSDictionary *params = @{@"mobile":self.phone.text,
                             @"certCode":self.code.text};
    [NetworkManager postWithApi:@"register" params:params success:^(id result) {
        AlertMessage(@"注册成功");
    } fail:^(NSError *error) {
        
    }];
}


/**
 *  同意协议按钮
 *
 *  @param sender
 */
- (IBAction)agree:(UIButton *)sender {
    sender.selected = !sender.selected;
    [sender setImage:[UIImage imageNamed:@""] forState:UIControlStateSelected];
}

/**
 *  展示用户注册协议
 *
 *  @param sender
 */
- (IBAction)showProtocol:(UIButton *)sender {
    
    XXXProtocolTipView *pro = [[XXXProtocolTipView alloc]initWithFrame:CGRectMake(20, 80, SWIDTH-40, SHEIGHT-100)];
    [self.view addSubview:pro];
    pro.transform = CGAffineTransformMakeScale(0, 0);
    [UIView animateWithDuration:.5 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseIn animations:^{
        pro.transform = CGAffineTransformMakeScale(1, 1);
    } completion:^(BOOL finished) {
        
    }];
}

/**
 *  更新弧度
 */
- (void)updatePath{
    if (self.scrollView.contentOffset.y<=0) {
         self.layer.path = [self curPath:self.scrollView.contentOffset.y].CGPath;
            self.background.layer.transform = CATransform3DMakeScale(1-self.scrollView.contentOffset.y/200,1-self.scrollView.contentOffset.y/200, 1);
    }
    if (self.scrollView.contentOffset.y<-63) {
            self.background.layer.transform = CATransform3DMakeScale(1+63/200.0,1+63/200.0, 1);
    }
}

- (UIBezierPath *)curPath:(CGFloat)offSetY{
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGPoint center = CGPointMake(SWIDTH/2, 550);
    if (offSetY<0) {
        center = CGPointMake(SWIDTH/2*(1-offSetY/200), 550-offSetY*50);
    }
    CGFloat H = self.background.frame.size.height;
    CGFloat radius = sqrt((SWIDTH/2)*(SWIDTH/2)+(600-offSetY*50-H)*(600-offSetY*50-H));
    [path addArcWithCenter:center radius:radius startAngle:0 endAngle:M_PI clockwise:NO];
    return path;
}

- (void)dealloc{
    [self.displayLink invalidate];
}
@end
