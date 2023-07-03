//
//  ZLHTTPSessionManager.h
//  BoYi
//
//  Created by zhaolei on 2018/5/8.
//  Copyright © 2018年 hengwu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZLHTTPFileModel.h"

///请求失败状态
typedef NS_ENUM (NSInteger , ZLHttpErrorState){
    ///请求正常
    ZLHttpErrorStateNull = 0,
    ///服务器挂掉、访问地址不存在
    ZLHttpErrorStateServerFailure ,
    ///超时
    ZLHttpErrorStateTimeout ,
    ///断网
    ZLHttpErrorStateNoNetwork
};

///网络状态
typedef NS_ENUM(NSInteger, ZLHTTPSessionNetworkStatus) {
    ///未知状态
    ZLHTTPSessionNetworkStatusUnknown          = -1,
    ///未联网
    ZLHTTPSessionNetworkStatusNotReachable     = 0,
    ///流量
    ZLHTTPSessionNetworkStatusReachableViaWWAN = 1,
    ///WIFI
    ZLHTTPSessionNetworkStatusReachableViaWiFi = 2,
};

/// 请求方式
typedef NS_ENUM (NSInteger , HTTPMethod){
    get = 0,
    head ,
    post ,
    put ,
    patch ,
    delete
};



@interface ZLHTTPSessionManager : NSObject

///请求时间  默认30秒  超过30秒后请求会以ZLHttpErrorStateTimeout的错误类型返回error
@property (nonatomic,unsafe_unretained) NSTimeInterval requestTime;
///追加请求头
@property (nonatomic,strong,nullable) NSMutableDictionary *httpHeaderM;
///当前网络状态
@property (nonatomic,unsafe_unretained) ZLHTTPSessionNetworkStatus networkStatus;
///调试时的前缀
@property (nonatomic,strong) NSString * _Nullable debugPrefix;
///发布时的前缀
@property (nonatomic,strong) NSString * _Nullable onlinePrefix;
///是否是发布环境
@property (nonatomic,unsafe_unretained) BOOL online;
///打印日志
@property (nonatomic,unsafe_unretained) BOOL showLogs;

///获取实例
+ (instancetype _Nonnull )shared;

/**AppDelegate配置项
 *@param debugPrefix 调试时的前缀
 *@param onlinePrefix 发布时的前缀
 *@param online 是否是发布环境
 *@param showLogs 打印日志
 *@param networkComplete 网络发生变化时的回调
 */
+ (void)configDebugUrlPrefix:(NSString *_Nullable)debugPrefix OnlineUrlPrefix:(NSString *_Nullable)onlinePrefix Online:(BOOL)online ShowLogs:(BOOL)showLogs NetworkState:(void(^_Nullable)(ZLHTTPSessionNetworkStatus state))networkComplete;



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
                                   failure:(nullable void (^)(NSURLSessionDataTask * _Nonnull task, NSError * _Nullable error))failure;


/**
 * POST请求 --  文件上传
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
                                failure:(nullable void (^)(NSURLSessionDataTask * _Nonnull task, NSError * _Nullable error))failure;

@end
