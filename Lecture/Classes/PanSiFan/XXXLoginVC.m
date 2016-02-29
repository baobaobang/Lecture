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
#import "XXXUser.h"
#import "XXXMainPageVC.h"

@interface XXXLoginVC()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageLead;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageTrail;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageTop;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (nonatomic, strong) dispatch_source_t timer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *distance;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logoTop;
@property (weak, nonatomic) IBOutlet UIButton *checkBox;

@end

@implementation XXXLoginVC

- (void)viewDidLoad{
    [super viewDidLoad];
    [self setSubViews];
    
    //self.titleLabel.text = @"用户登录";
    self.title = @"用户登录";
    self.imageLead.constant = self.imageTrail.constant = SWIDTH/2-self.avatar.frame.size.width/2;
    CGFloat des = 0.0;
    if (iPhone4s) {
        des = 60;
    }
    if (iPhone5s) {
        des = 85;
    }
    if (iPhone6) {
        des = 85;
        self.logoTop.constant = 60;
    }
    CGSize size = [UIScreen mainScreen].currentMode.size;
    NSLog(@"%f---%f",size.width,size.height);
    if (iPhone6Plus) {
        des = 85;
    }
    self.distance.constant = des;
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

- (IBAction)getCertCode:(UIButton *)sender {
    if (self.phone.text.length <= 6) {
        [SVProgressHUD showErrorWithStatus:@"手机号不正确"];
        return;
    }
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
- (IBAction)isDoctor:(UIButton *)sender {
    sender.selected = !sender.selected;
}

- (IBAction)login:(id)sender {
    
    if (self.phone.text.length <= 6 || self.password.text.length < 4) {
        [SVProgressHUD showErrorWithStatus:@"信息不正确"];
        return;
    }
    [self.curTextField resignFirstResponder];
    NSDictionary *params = @{@"mobile":self.phone.text,
                             @"certCode":self.password.text
//                             ,@"type":@(!self.checkBox.selected)
                             };
    [NetworkManager postWithApi:@"register" params:params success:^(id result) {
        if ([result[@"ret"] integerValue] == 0) {
            UserDefaultsSave(result[@"data"][@"token"], @"access_token");
            if ([result[@"data"][@"type"] integerValue] == 1) {
                UserDefaultsSave(@"expert", @"isExpert");
            }
            UserDefaultsSave(@"mobile", @"mobile");//FIXME:
            [SVProgressHUD showSuccessWithStatus:@"登录成功"];
            // 登陆成功后的操作
            if (self.isFromLeftMenu) {
                // 如果是侧滑进来的登陆页面，就返回首页
                AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                XXNavigationController *nav = [[XXNavigationController alloc]initWithRootViewController:[[XXXMainPageVC alloc]init]];
                [delegate.sliderMenu changeMainViewController:nav close:YES];
            }else{
                // 如果是push进来的登陆页面，就pop掉
                [self.navigationController popViewControllerAnimated:YES];
            }
            
        }
    } fail:^(NSError *error) {
        
    }];
}

- (IBAction)thirdLogin:(UIButton *)sender
{
    switch (sender.tag) {
        case 1001:{

            UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession];
            
            snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
                
                if (response.responseCode == UMSResponseCodeSuccess) {
                    
                    UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary]valueForKey:UMShareToWechatSession];
                    [self dealWithUserInfo:snsAccount type:THIRDPARTYTYPE_WX];
                }
                
            });
        }
            break;
        case 1002:{

            UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina];
            
            snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
                
                //          获取微博用户名、uid、token等
                
                if (response.responseCode == UMSResponseCodeSuccess) {
//                    NSDictionary *dic =  [UMSocialAccountManager socialAccountDictionary];
                    UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToSina];
                    [self dealWithUserInfo:snsAccount type:THIRDPARTYTYPE_WB];
                    //拿到用户平台数据
                    
                }});
        }
            break;
        case 1003:{

            UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQQ];
            
            snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
                
                //          获取微博用户名、uid、token等
                
                if (response.responseCode == UMSResponseCodeSuccess) {
                    
                    UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToQQ];
                    [self dealWithUserInfo:snsAccount type:THIRDPARTYTYPE_QQ];
                }});
        }
            break;
        default:
            break;
    }
}

//type 1-QQ   2-微信  3-微博
- (void)dealWithUserInfo:(UMSocialAccountEntity *)snsAccount type:(THIRDPARTYTYPE)type{

    XXXUser *user = [[XXXUser alloc]init];
    user.thirdPartyType = type;
    user.token = snsAccount.accessToken;
    
    switch (type) {
        case THIRDPARTYTYPE_WX:
            user.weChatNickName = snsAccount.userName;
            user.weChatOpenID = snsAccount.openId;
            user.weChatHeadPic = snsAccount.iconURL;
            break;
        case THIRDPARTYTYPE_WB:
            user.weboNickName = snsAccount.userName;
            user.weboUid = snsAccount.usid;
            user.weboHeadPic = snsAccount.iconURL;
            break;
        case THIRDPARTYTYPE_QQ:
            user.qqNickName = snsAccount.userName;
            user.qqOpenID = snsAccount.openId;
            user.qqHeadPic = snsAccount.iconURL;
            break;
        default:
            break;
    }
    [self bind:user];
}
- (void)bind:(XXXUser *)user{
    XXXRegisterVC *regist = [[XXXRegisterVC alloc]init];
    regist.user = user;
    [self.navigationController pushViewController:regist animated:YES];
}

@end
