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

@interface NetworkManager()

@property (nonatomic, strong) AFHTTPSessionManager *manager;

@end


@implementation NetworkManager

+ (void)getWithApi:(NSString *)api params:(NSDictionary *)params success:(SuccessBlock)successBlock fail:(FailBlock)failBlock{
    NSString *url = [NSString stringWithFormat:@"%@/api/%@",HOST,api];
    AFHTTPSessionManager *manager = [NetworkManager shareNetworkManager].manager;
    manager.requestSerializer.timeoutInterval = 2;
    //NSLog(@"%@",ACCESS_TOKEN);
    
    [manager.requestSerializer setValue:ACCESS_TOKEN forHTTPHeaderField:@"token"];
    [manager GET:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        successBlock(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failBlock(error);
    }];
}


+ (void)postWithApi:(NSString *)api params:(NSDictionary *)params success:(SuccessBlock)successBlock fail:(FailBlock)failBlock{
    NSString *url = [NSString stringWithFormat:@"%@/api/%@",HOST,api];
    AFHTTPSessionManager *manager = [NetworkManager shareNetworkManager].manager;
    manager.requestSerializer =  [AFJSONRequestSerializer serializer];
    manager.requestSerializer.timeoutInterval = 2;
    [manager.requestSerializer setValue:ACCESS_TOKEN forHTTPHeaderField:@"token"];
    [manager POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        successBlock(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failBlock(error);
    }];
}



+ (void)qiniuUpload:(NSData *)data progress:(QNUpProgressHandler)progressHandler success:(SuccessBlock)successBlock fail:(FailBlock)failBlock isImageType:(BOOL)isImageType{
    NSString *token = UserDefaultsGet(@"qiniutoken");
    //QNUploadManager *upManager = [[QNUploadManager alloc] init];
    QNUploadManager *upManager = [QNUploadManager sharedInstanceWithConfiguration:[QNConfiguration build:^(QNConfigurationBuilder *builder) {
        builder.timeoutInterval = 10;
    }]];
    [upManager putData:data key:nil token:token
              complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                  if (resp) {
                      successBlock([NSString stringWithFormat:@"%@/%@",QINIU_HOST,resp[@"key"]]);
                  }else{
                      failBlock([NSError errorWithDomain:@"上传失败" code:-1 userInfo:nil]);
                  }
              } option:(!isImageType ? [[QNUploadOption alloc] initWithMime:@"audio/mpeg" progressHandler:progressHandler params:nil checkCrc:nil cancellationSignal:nil]:[[QNUploadOption alloc] initWithMime:nil progressHandler:progressHandler params:nil checkCrc:nil cancellationSignal:nil])];
}

+ (void)qiniuUpload:(NSArray<UIImage *> *)imageArray progress:(QNUpProgressHandler)progressHandler success:(SuccessBlock)successBlock fail:(FailBlock)failBlock allcompleteBlock:(AllCompleteBlock) allcompleteBlock{
    
    NSString *token = UserDefaultsGet(@"qiniutoken");
    __weak NetworkManager *weakManager = [NetworkManager shareNetworkManager];
    int num = (int)imageArray.count;
    
    for (UIImage *image in imageArray) {
        QNUploadManager *upManager = [[QNUploadManager alloc]initWithConfiguration:[QNConfiguration build:^(QNConfigurationBuilder *builder) {
            builder.timeoutInterval = 2;
        }]];
        NSData *data = UIImageJPEGRepresentation(image, 1);
        [upManager putData:data key:nil token:token
                  complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                      if (resp) {
                          successBlock([NSString stringWithFormat:@"%@/%@",QINIU_HOST,resp[@"key"]]);
                          [weakManager.resultArray addObject:[NSString stringWithFormat:@"%@/%@",QINIU_HOST,resp[@"key"]]];
                          if (weakManager.resultArray.count == num) {
                              allcompleteBlock([weakManager.resultArray copy]);
                              [weakManager.resultArray removeAllObjects];
                          }
                      }else{
                          failBlock(info.error);
                      }
                  } option:[[QNUploadOption alloc] initWithMime:nil progressHandler:progressHandler params:nil checkCrc:nil cancellationSignal:nil]];
        
    }
   
    
}


+ (instancetype)shareNetworkManager{
    static dispatch_once_t onceToken;
    static NetworkManager *sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        if (!sharedInstance) {
            sharedInstance = [[self alloc]init];
        }
    });
    return sharedInstance;
}

- (AFHTTPSessionManager *)manager{
    if (!_manager) {
        _manager = [AFHTTPSessionManager manager];
    }
    return _manager;
}

- (NSMutableArray *)resultArray{
    if (!_resultArray) {
        _resultArray = [NSMutableArray array];
    }
    return _resultArray;
}

//+ (void)uploadWithApi:(NSString *)api filePath:(NSString *)path success:(SuccessBlock)successBlock fail:(FailBlock)failBlock{
//    NSURL *url;
//    NSURL *filePath = [NSURL URLWithString:path];
//    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
//    AFURLSessionManager *manager = [[AFURLSessionManager alloc]initWithSessionConfiguration:configuration];
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//    
//    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithRequest:request fromFile:filePath progress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
//        if (error) {
//            successBlock(responseObject);
//        }else{
//            failBlock(error);
//        }
//    }];
//    [uploadTask resume];
//}
//
//+ (void)uploadWithApi:(NSString *)api fileData:(NSData *)data success:(SuccessBlock)successBlock fail:(FailBlock)failBlock{
//    NSURL *url;
//    
//    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
//    AFURLSessionManager *manager = [[AFURLSessionManager alloc]initWithSessionConfiguration:configuration];
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//    
//    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithRequest:request fromData:data progress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
//        if (error) {
//            successBlock(responseObject);
//        }else{
//            failBlock(error);
//        }
//    }];
//    [uploadTask resume];
//}
//
//+(void)uploadWithApi:(NSString *)api files:(NSDictionary *)files success:(SuccessBlock)successBlock fail:(FailBlock)failBlock{
//    NSString *url;
//    NSDictionary *params;
//    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//    } error:nil];
//    
//    AFURLSessionManager *manager = [[AFURLSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
//    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithStreamedRequest:request progress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
//        if (error) {
//            successBlock(responseObject);
//        }else{
//            failBlock(error);
//        }
//    }];
//    [uploadTask resume];
//}
//


@end
