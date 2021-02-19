//
//  ZLHTTPSessionManager.m
//  BoYi
//
//  Created by zhaolei on 2018/5/8.
//  Copyright © 2018年 hengwu. All rights reserved.
//

#import "ZLHTTPSessionManager.h"
#import "ZLHTTPRequestProcess.h"
#import "AFNetworking.h"

@interface ZLHTTPSessionManager ()

///请求的事件代理
@property (nonatomic,strong) ZLHTTPRequestProcess *delegate;
///解析类型
@property (nonatomic,strong) NSSet *responseTypeSet;
///当前网络状态
@property (nonatomic,unsafe_unretained) AFNetworkReachabilityStatus _networkStatus;

@end

@implementation ZLHTTPSessionManager

+ (instancetype)shared {
    static ZLHTTPSessionManager *sessionManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sessionManager = [self new];
        sessionManager.delegate = [ZLHTTPRequestProcess new];
        sessionManager.delegate.requestManager = [AFHTTPSessionManager manager];
    });
    return sessionManager;
}

#pragma mark - Set
- (void)setHttpHeaderM:(NSMutableDictionary *)httpHeaderM {
    _httpHeaderM = httpHeaderM;
    self.delegate.httpHeaderM = httpHeaderM;
}
- (void)setRequestTime:(NSTimeInterval)requestTime {
    _requestTime = requestTime;
    [self.delegate.requestManager.requestSerializer setTimeoutInterval:requestTime];
}

#pragma mark - Lazy
- (BOOL)online {
    return self.delegate.online;
}
- (NSSet *)responseTypeSet {
    if (!_responseTypeSet) {
        _responseTypeSet = [NSSet setWithObjects:@"text/html", @"text/json", @"text/javascript", @"application/json", @"text/plain", nil];
    }
    return _responseTypeSet;
}
- (ZLHTTPSessionNetworkStatus)networkStatus {
    return (ZLHTTPSessionNetworkStatus)self._networkStatus;
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
    manager.delegate.requestManager.responseSerializer.acceptableContentTypes = manager.responseTypeSet;
    manager.requestTime = 30;
    manager.delegate.requestManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.delegate.requestManager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.delegate.debugPrefix = debugPrefix;
    manager.delegate.onlinePrefix = onlinePrefix;
    manager.delegate.online = online;
    manager.delegate.showLogs = showLogs;
    //检测网络(持续监测……)
    AFNetworkReachabilityManager *reachabilityManager = [AFNetworkReachabilityManager sharedManager];
    [reachabilityManager startMonitoring];
    __weak typeof(manager)weakManager = manager;
    [reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        weakManager._networkStatus = status;
        weakManager.delegate.networkStatus = [[NSString stringWithFormat:@"%ld",(long)status] integerValue];
        if (networkComplete) {
            networkComplete(weakManager.delegate.networkStatus);
        }
    }];
}

/**GET请求
 *@param urlString 请求地址
 *@param dict 请求参数
 *@param isAddHeader 是否追加head头，如需增加，请在外界对本类属性httpHeaderM进行配置
 *@param cachePolicy 缓存策略
 *@param complete 处理结果
 *@return Task
 */
+ (NSURLSessionDataTask *_Nullable)GET:(NSString *_Nonnull)urlString Params:(NSDictionary *_Nullable)dict AddHttpHeader:(BOOL)isAddHeader CachePolicy:(NSURLRequestCachePolicy)cachePolicy Results:(void (^_Nullable)(ZLHttpErrorState sessionErrorState, id _Nullable responseObject))complete {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    ZLHTTPSessionManager *manager = [self shared];
    manager.delegate.requestManager.responseSerializer.acceptableContentTypes = manager.responseTypeSet;
    return [manager.delegate GET:urlString Params:dict AddHttpHeader:isAddHeader CachePolicy:cachePolicy Results:complete];
}

/**POST请求 --  追加图片数据
 *@param urlString 请求地址
 *@param dict 请求参数
 *@param isAddHeader 是否追加head头，如需增加，请在外界对本类属性httpHeaderM进行配置
 *@param cachePolicy 缓存策略
 *@param complete 处理结果
 *@return Task
 */
+ (NSURLSessionDataTask *_Nullable)POST:(NSString *_Nonnull)urlString Params:(NSDictionary *_Nullable)dict ModelArray:(NSArray <ZLHTTPFileModel *>*_Nullable)modelArray AddHttpHeader:(BOOL)isAddHeader CachePolicy:(NSURLRequestCachePolicy)cachePolicy Results:(void (^_Nullable)(ZLHttpErrorState sessionErrorState, id _Nullable responseObject))complete {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    ZLHTTPSessionManager *manager = [self shared];
    manager.delegate.requestManager.responseSerializer.acceptableContentTypes = manager.responseTypeSet;
    return [manager.delegate POST:urlString Params:dict ModelArray:modelArray AddHttpHeader:isAddHeader CachePolicy:cachePolicy Results:complete];
}


@end
