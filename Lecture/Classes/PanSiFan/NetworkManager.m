//
//  NetworkManager.m
//  lecture
//
//  Created by mortal on 16/1/20.
//  Copyright © 2016年 禾医健康科技. All rights reserved.
//

#import "NetworkManager.h"
#import "AFNetworking.h"


#define HOST @"http://121.42.171.213:3000"




@implementation NetworkManager

+ (void)getWithApi:(NSString *)api params:(NSDictionary *)params success:(SuccessBlock)successBlock fail:(FailBlock)failBlock{
    NSString *url = [NSString stringWithFormat:@"%@/api/%@",HOST,api];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        successBlock(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failBlock(error);
    }];
}


+ (void)postWithApi:(NSString *)api params:(NSDictionary *)params success:(SuccessBlock)successBlock fail:(FailBlock)failBlock{
    NSString *url = [NSString stringWithFormat:@"%@/api/%@",HOST,api];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        successBlock(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failBlock(error);
    }];
}


+ (void)uploadWithApi:(NSString *)api filePath:(NSString *)path success:(SuccessBlock)successBlock fail:(FailBlock)failBlock{
    NSURL *url;
    NSURL *filePath = [NSURL URLWithString:path];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc]initWithSessionConfiguration:configuration];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithRequest:request fromFile:filePath progress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            successBlock(responseObject);
        }else{
            failBlock(error);
        }
    }];
    [uploadTask resume];
}

+ (void)uploadWithApi:(NSString *)api fileData:(NSData *)data success:(SuccessBlock)successBlock fail:(FailBlock)failBlock{
    NSURL *url;
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc]initWithSessionConfiguration:configuration];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithRequest:request fromData:data progress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            successBlock(responseObject);
        }else{
            failBlock(error);
        }
    }];
    [uploadTask resume];
}

+(void)uploadWithApi:(NSString *)api files:(NSDictionary *)files success:(SuccessBlock)successBlock fail:(FailBlock)failBlock{
    NSString *url;
    NSDictionary *params;
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
    } error:nil];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithStreamedRequest:request progress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            successBlock(responseObject);
        }else{
            failBlock(error);
        }
    }];
    [uploadTask resume];
}



@end
