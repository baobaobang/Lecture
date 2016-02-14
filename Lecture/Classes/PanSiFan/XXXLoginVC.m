//
//  XXXLoginVC.m
//  lecture
//
//  Created by mortal on 16/1/22.
//  Copyright © 2016年 禾医健康科技. All rights reserved.
//

#import "XXXLoginVC.h"
#import "UMSocial.h"
#import "UIView+RoundAndShadow.h"
#import "XXXRegisterVC.h"

@interface XXXLoginVC()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageLead;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageTrail;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageTop;
//@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UIImageView *avatar;

@end

@implementation XXXLoginVC

- (void)viewDidLoad{
    [super viewDidLoad];
    [self setSubViews];
    self.navigationItem.title = @"公益讲堂";
    
    self.imageLead.constant = self.imageTrail.constant = SWIDTH/2-self.avatar.frame.size.width/2;
}


- (void)setSubViews{
    [self.loginBtn shadowWithColor:[UIColor grayColor] size:CGSizeMake(0.5, 0.5) opacity:1];
    UIImageView *tel = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tel"]];
    tel.frame = CGRectMake(15, 15, 20, 20);
    UIView *back1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 40, 50)];
    [back1 addSubview:tel];
    self.phone.leftView = back1;
    self.phone.leftViewMode = UITextFieldViewModeAlways;
    
    UIImageView *pass = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"password"]];
    pass.frame = CGRectMake(15, 15, 20, 20);
    UIView *back2 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 40, 50)];
    [back2 addSubview:pass];
    self.password.leftView = back2;
    self.password.leftViewMode = UITextFieldViewModeAlways;

    
}

/**
 *  忘记密码
 *
 *  @param sender
 */
- (IBAction)forgetPassword:(UIButton *)sender {
    
}

/**
 *  新用户注册
 *
 *  @param sender
 */
- (IBAction)regist:(UIButton *)sender {
    XXXRegisterVC *registVC = [[XXXRegisterVC alloc]init];
    [self.navigationController pushViewController:registVC animated:YES];
}


- (IBAction)login:(id)sender {
    NSDictionary *params = @{@"":self.phone.text,
                             @"":self.password.text};
    
}

- (IBAction)thirdLogin:(UIButton *)sender
{
    switch (sender.tag) {
        case 1001:{
            NSLog(@"微信登陆...");
            UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession];
            
            snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
                
                if (response.responseCode == UMSResponseCodeSuccess) {
                    
                    UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary]valueForKey:UMShareToWechatSession];
                    
                }
                
            });
        }
            break;
        case 1002:{
            NSLog(@"微博登陆...");
            UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina];
            
            snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
                
                //          获取微博用户名、uid、token等
                
                if (response.responseCode == UMSResponseCodeSuccess) {
                    
                    UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToSina];
                    
                    //拿到用户平台数据
                    
                }});
        }
            break;
        case 1003:{
            NSLog(@"QQ登陆...");
            UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQQ];
            
            snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
                
                //          获取微博用户名、uid、token等
                
                if (response.responseCode == UMSResponseCodeSuccess) {
                    
                    UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToQQ];
                    
                }});
        }
            break;
        default:
            break;
    }
}


@end
