//
//  CXShareTool.h
//  Lecture
//
//  Created by 陈旭 on 16/2/29.
//  Copyright © 2016年 陈旭. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UMSocial.h>

@interface CXShareTool : NSObject
+ (void)shareInVc:(UIViewController *)vc url:(NSString *)url title:(NSString *)title shareText:(NSString *)shareText;
@end
