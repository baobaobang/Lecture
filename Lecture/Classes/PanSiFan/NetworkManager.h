//
//  NetworkManager.h
//  lecture
//
//  Created by mortal on 16/1/20.
//  Copyright © 2016年 禾医健康科技. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QiniuSDK.h"
typedef void (^SuccessBlock)(id result);
typedef void (^FailBlock)(NSError *error);
typedef void (^AllCompleteBlock)(id result);

@interface NetworkManager : NSObject

@property (nonatomic, strong) NSMutableArray *resultArray;

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
 *  七牛上传
 *
 *  @param data            data
 *  @param progressHandler 进度
 *  @param successBlock    成功
 *  @param failBlock       失败
 *  @param isImageType     是否图片
 */
+ (void)qiniuUpload:(NSData *)data progress:(QNUpProgressHandler)progressHandler success:(SuccessBlock)successBlock fail:(FailBlock)failBlock isImageType:(BOOL)isImageType;


+ (void)qiniuUpload:(NSArray<UIImage *> *)imageArray progress:(QNUpProgressHandler)progressHandler success:(SuccessBlock)successBlock fail:(FailBlock)failBlock allcompleteBlock:(AllCompleteBlock) allcompleteBlock;

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


+ (instancetype)shareNetworkManager;
@end
