//
//  NetworkManager.h
//  lecture
//
//  Created by mortal on 16/1/20.
//  Copyright © 2016年 禾医健康科技. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^SuccessBlock)(id result);
typedef void (^FailBlock)(NSError *error);
@interface NetworkManager : NSObject



+ (void)getWithApi:(NSString *)api params:(NSDictionary *)params success:(SuccessBlock)successBlock fail:(FailBlock)failBlock;
/**
 *  POST请求
 *
 *  @param api         api 非全url
 *  @param params      参数
 *  @param successBlock response结果处理
 *  @param failBlock   错误处理
 */
+ (void)postWithApi:(NSString *)api params:(NSDictionary *)params success:(SuccessBlock)successBlock fail:(FailBlock)failBlock;

/**
 *  通过文件路径上传文件
 *
 *  @param api         api 非全url
 *  @param path        文件路径
 *  @param successBlock response结果处理
 *  @param failBlock   错误处理
 */
+ (void)uploadWithApi:(NSString *)api filePath:(NSString *)path success:(SuccessBlock)successBlock fail:(FailBlock)failBlock;

/**
 *  上传文件data
 *
 *  @param api         api 非全url
 *  @param data        文件主体
 *  @param successBlock response结果处理
 *  @param failBlock   错误处理
 */
+ (void)uploadWithApi:(NSString *)api fileData:(NSData *)data success:(SuccessBlock)successBlock fail:(FailBlock)failBlock;
/**
 *  多文件上传
 *
 *  @param api         api 非全url
 *  @param files       文件dic
 *  @param successBlock response结果处理
 *  @param failBlock   错误处理
 */
+(void)uploadWithApi:(NSString *)api files:(NSDictionary *)files success:(SuccessBlock)successBlock fail:(FailBlock)failBlock;

@end
