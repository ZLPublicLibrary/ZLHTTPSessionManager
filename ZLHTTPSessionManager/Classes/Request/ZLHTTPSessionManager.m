//
//  ZLHTTPSessionManager.m
//  BoYi
//
//  Created by zhaolei on 2018/5/8.
//  Copyright © 2018年 hengwu. All rights reserved.
//

#import "ZLHTTPSessionManager.h"
#import "NSArray+ZLHttpDataProcess.h"
#import "NSDictionary+ZLHttpDataProcess.h"
#import <AFNetworking/AFNetworking.h>

@interface ZLHTTPSessionManager ()

///解析类型
@property (nonatomic,strong) NSSet *responseTypeSet;
///当前网络状态
@property (nonatomic,unsafe_unretained) AFNetworkReachabilityStatus networkStatus_AF;
///请求的管理对象
@property (nonatomic,strong) AFHTTPSessionManager * _Nonnull requestManager;

@end

@implementation ZLHTTPSessionManager

+ (instancetype)shared {
    static ZLHTTPSessionManager *sessionManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sessionManager = [self new];
        sessionManager.basicDataTypeToString = true;
        sessionManager.requestManager = [AFHTTPSessionManager manager];
    });
    return sessionManager;
}

#pragma mark - Set
- (void)setHttpHeaderM:(NSMutableDictionary *)httpHeaderM {
    _httpHeaderM = httpHeaderM;
    self.httpHeaderM = httpHeaderM;
}
- (void)setRequestTime:(NSTimeInterval)requestTime {
    _requestTime = requestTime;
    [self.requestManager.requestSerializer setTimeoutInterval:requestTime];
}

#pragma mark - Lazy
- (NSSet *)responseTypeSet {
    if (!_responseTypeSet) {
        _responseTypeSet = [NSSet setWithObjects:@"text/html", @"text/json", @"text/javascript", @"application/json", @"text/plain", nil];
    }
    return _responseTypeSet;
}
- (ZLHTTPSessionNetworkStatus)networkStatus {
    return (ZLHTTPSessionNetworkStatus)self.networkStatus_AF;
}

/**AppDelegate配置项
 *@param debugPrefix 调试时的前缀
 *@param onlinePrefix 发布时的前缀
 *@param online 是否是发布环境
 *@param showLogs 打印日志
 *@param networkComplete 网络发生变化时的回调
 */
+ (void)configDebugUrlPrefix:(NSString *_Nullable)debugPrefix OnlineUrlPrefix:(NSString *_Nullable)onlinePrefix Online:(BOOL)online ShowLogs:(BOOL)showLogs NetworkState:(void(^_Nullable)(ZLHTTPSessionNetworkStatus state))networkComplete {
    ZLHTTPSessionManager *manager = [self shared];
    manager.requestManager.responseSerializer.acceptableContentTypes = manager.responseTypeSet;
    manager.requestTime = 30;
    manager.requestManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.requestManager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.debugPrefix = debugPrefix;
    manager.onlinePrefix = onlinePrefix;
    manager.online = online;
    manager.showLogs = showLogs;
    //检测网络(持续监测……)
    AFNetworkReachabilityManager *reachabilityManager = [AFNetworkReachabilityManager sharedManager];
    [reachabilityManager startMonitoring];
    __weak typeof(manager)weakManager = manager;
    [reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        weakManager.networkStatus_AF = status;
        weakManager.networkStatus = [[NSString stringWithFormat:@"%ld",(long)status] integerValue];
        if (networkComplete) {
            networkComplete(weakManager.networkStatus);
        }
    }];
}

/**
 根据HTTPMethod创建一个NSURLSessionDataTask
 
 @param method 请求的方式
 @param urlString 请求的地址
 @param dict 请求的参数
 @param downloadProgress 下载的进度
 @param success 成功的事件回调
 @param failure 失败的事件回调
 @param isAddHeader 是否允许添加 -- 例如：未登录时使用false来控制不传token
 @param cachePolicy 缓存策略
 */
+ (nullable NSURLSessionDataTask *)request:(nonnull NSString *)urlString
                                HTTPMethod:(HTTPMethod)method
                                    Params:(nullable id)dict
                             AddHttpHeader:(BOOL)isAddHeader
                               CachePolicy:(NSURLRequestCachePolicy)cachePolicy
                          downloadProgress:(nullable void (^)(NSProgress * _Nonnull downloadProgress))downloadProgress
                                   success:(nullable void (^)(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject))success
                                   failure:(nullable void (^)(NSURLSessionDataTask * _Nonnull task, NSError * _Nullable error))failure {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    ZLHTTPSessionManager *manager = [self shared];
    manager.requestManager.responseSerializer.acceptableContentTypes = manager.responseTypeSet;
    manager.requestManager.requestSerializer.cachePolicy = cachePolicy;
    for (NSString *key in manager.httpHeaderM.allKeys) {
        if (isAddHeader) {
            [manager.requestManager.requestSerializer setValue:manager.httpHeaderM[key] forHTTPHeaderField:key];
        }else {
            [manager.requestManager.requestSerializer setValue:nil forHTTPHeaderField:key];
        }
    }
    urlString = [urlString rangeOfString:@"http"].location != NSNotFound ? urlString : [NSString stringWithFormat:@"%@%@",manager.online ? manager.onlinePrefix : manager.debugPrefix,urlString];
    if (method == get) {
        return [manager.requestManager GET:urlString parameters:dict headers:manager.httpHeaderM progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [self completionResponseObject:responseObject urlString:urlString dict:dict task:task Handler:success];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self failure:error urlString:urlString dict:dict task:task handler:failure];
        }];
    }else if (method == head) {
        return [manager.requestManager HEAD:urlString parameters:dict headers:manager.httpHeaderM success:^(NSURLSessionDataTask * _Nonnull task) {
            [self completionResponseObject:nil urlString:urlString dict:dict task:task Handler:success];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self failure:error urlString:urlString dict:dict task:task handler:failure];
        }];
    }else if (method == post) {
        return [manager.requestManager POST:urlString parameters:dict headers:manager.httpHeaderM progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [self completionResponseObject:responseObject urlString:urlString dict:dict task:task Handler:success];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self failure:error urlString:urlString dict:dict task:task handler:failure];
        }];
    }else if (method == put) {
        return [manager.requestManager PUT:urlString parameters:dict headers:manager.httpHeaderM success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [self completionResponseObject:responseObject urlString:urlString dict:dict task:task Handler:success];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self failure:error urlString:urlString dict:dict task:task handler:failure];
        }];
    }else if (method == patch) {
        return [manager.requestManager PATCH:urlString parameters:dict headers:manager.httpHeaderM success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [self completionResponseObject:responseObject urlString:urlString dict:dict task:task Handler:success];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self failure:error urlString:urlString dict:dict task:task handler:failure];
        }];
    }else { // delete
        return [manager.requestManager DELETE:urlString parameters:dict headers:manager.httpHeaderM success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [self completionResponseObject:responseObject urlString:urlString dict:dict task:task Handler:success];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self failure:error urlString:urlString dict:dict task:task handler:failure];
        }];
    }
}

/// 响应成功结果
+ (void)completionResponseObject:(id)response urlString:(nonnull NSString *)urlString dict:(nullable id)dict task:(NSURLSessionDataTask * _Nonnull)task Handler:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        id responseObject = response;
        //将结果转换为字典
        if ([responseObject isKindOfClass:[NSData class]] && responseObject) {
            responseObject = [NSJSONSerialization JSONObjectWithData:responseObject options:(NSJSONReadingMutableContainers) error:nil];
        }
        if ([responseObject isKindOfClass:[NSDictionary class]] && responseObject) {
            responseObject = [((NSDictionary *)responseObject) screeningNull:[self shared].basicDataTypeToString];
        }else if ([responseObject isKindOfClass:[NSArray class]] && responseObject) {
            responseObject = [((NSArray *)responseObject) screeningNull:[self shared].basicDataTypeToString];
        }
        //调试打印
        if ([self shared].showLogs && responseObject) {
            NSString *message = nil;
            if (responseObject[@"message"]) {
                message = responseObject[@"message"];
            }
            if (responseObject[@"msg"]) {
                message = responseObject[@"msg"];
            }
            NSString *headers = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:[self shared].requestManager.requestSerializer.HTTPRequestHeaders options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding];
            NSString *params = nil;
            if (dict) {
                params = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding];
            }
            NSString *resultsString = nil;
            if ([responseObject isKindOfClass:[NSDictionary class]] || [responseObject isKindOfClass:[NSArray class]]) {
                resultsString = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding];
            }else {
                resultsString = responseObject;
            }
            NSLog(@"\n收到成功后的回执：%@\n\n%@\n%@\n%@\n\n%@\n\n\n.", message, urlString, params, headers, resultsString);
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            //处理下文
            success(task, responseObject);
        });
    });
}

/// 响应失败结果
+ (void)failure:(NSError * _Nonnull)error urlString:(nonnull NSString *)urlString dict:(nullable id)dict task:(NSURLSessionDataTask * _Nonnull)task handler:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //调试打印
        if ([self shared].showLogs) {
            NSString *message = @"请求失败";
            NSString *headers = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:[self shared].requestManager.requestSerializer.HTTPRequestHeaders options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding];
            NSString *params = nil;
            if (dict) {
                params = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding];
            }
            NSString *errorStirng = [[NSString alloc] initWithData:error.userInfo[@"com.alamofire.serialization.response.error.data"] encoding:NSUTF8StringEncoding];
            NSLog(@"\n收到成功后的回执：%@\n\n%@\n%@\n%@\n%@\n%@\n\n\n.", message, urlString, params, headers, errorStirng ,error);
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            //处理下文
            failure(task, error);
        });
    });
}



/**
 * POST请求 --  追加图片数据
 * @param urlString 请求地址
 * @param dict 请求参数
 * @param isAddHeader 是否追加head头，如需增加，请在外界对本类属性httpHeaderM进行配置
 * @param cachePolicy 缓存策略
 * @param modelArray 文件模型
 * @param uploadProgress 上传进度
 * @param success 成功事件
 * @param failure 失败事件
 * @return Task
 */
+ (NSURLSessionDataTask *_Nullable)POST:(NSString *_Nonnull)urlString
                                 Params:(NSDictionary *_Nullable)dict
                             ModelArray:(NSArray <ZLHTTPFileModel *>*_Nullable)modelArray
                          AddHttpHeader:(BOOL)isAddHeader
                            CachePolicy:(NSURLRequestCachePolicy)cachePolicy
                         uploadProgress:(nullable void (^)(NSProgress * _Nonnull uploadProgress))uploadProgress
                                success:(nullable void (^)(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject))success
                                failure:(nullable void (^)(NSURLSessionDataTask * _Nonnull task, NSError * _Nullable error))failure {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    ZLHTTPSessionManager *manager = [self shared];
//    manager.requestManager.responseSerializer.acceptableContentTypes = manager.responseTypeSet;
    manager.requestManager.requestSerializer.cachePolicy = cachePolicy;
    for (NSString *key in manager.httpHeaderM.allKeys) {
        if (isAddHeader) {
            [manager.requestManager.requestSerializer setValue:manager.httpHeaderM[key] forHTTPHeaderField:key];
        }else {
            [manager.requestManager.requestSerializer setValue:nil forHTTPHeaderField:key];
        }
    }
    urlString = [urlString rangeOfString:@"http"].location != NSNotFound ? urlString : [NSString stringWithFormat:@"%@%@",manager.online ? manager.onlinePrefix : manager.debugPrefix,urlString];
    return [manager.requestManager POST:urlString parameters:dict headers:manager.httpHeaderM constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        if (modelArray.count) {
            for (NSInteger a = 0; a < modelArray.count; a++) {
                ZLHTTPFileModel *fileModel = modelArray[a];
                [formData appendPartWithFileData:fileModel.fileData name:fileModel.fileName fileName:fileModel.filePath mimeType:fileModel.fileType];
            }
        }
    } progress:uploadProgress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [self completionResponseObject:responseObject urlString:urlString dict:dict task:task Handler:success];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self failure:error urlString:urlString dict:dict task:task handler:failure];
    }];

}

@end
