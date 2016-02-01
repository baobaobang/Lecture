//
//  XXXLoginVC.m
//  lecture
//
//  Created by mortal on 16/1/22.
//  Copyright © 2016年 禾医健康科技. All rights reserved.
//

#import "XXXLoginVC.h"
#import "UMSocial.h"

@implementation XXXLoginVC
- (IBAction)test:(UIButton *)sender {
    sender.tag = 1002;
    [self thirdLogin:sender];
}



- (void)thirdLogin:(UIButton *)sender
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
