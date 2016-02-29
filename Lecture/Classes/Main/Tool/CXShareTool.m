//
//  CXShareTool.m
//  Lecture
//
//  Created by 陈旭 on 16/2/29.
//  Copyright © 2016年 陈旭. All rights reserved.
//

#import "CXShareTool.h"

@implementation CXShareTool
+ (void)shareInVc:(UIViewController *)vc url:(NSString *)url title:(NSString *)title shareText:(NSString *)shareText{
    
    [UMSocialData defaultData].extConfig.wechatSessionData.url = url;
    [UMSocialData defaultData].extConfig.wechatSessionData.title = title;
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = url;
    [UMSocialData defaultData].extConfig.wechatTimelineData.title = title;
    [UMSocialData defaultData].extConfig.qqData.url = url;
    [UMSocialData defaultData].extConfig.qqData.title = title;
    [UMSocialData defaultData].extConfig.sinaData.urlResource.url = url;
    [UMSocialData defaultData].extConfig.sinaData.snsName = @"医讲堂";
    
    // 跳出分享页面
    [UMSocialSnsService presentSnsIconSheetView:vc
                                         appKey:UMKey
                                      shareText:shareText
                                     shareImage:[UIImage imageNamed:@"logo"]
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQQ,UMShareToSina,nil]
                                       delegate:nil];
}
@end
