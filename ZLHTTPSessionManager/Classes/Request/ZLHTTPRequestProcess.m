//
//  ZLHTTPRequestProcess.m
//  HTTPSessionManager
//
//  Created by zhaolei on 2018/12/20.
//  Copyright © 2018 赵磊. All rights reserved.
//

#import "ZLHTTPRequestProcess.h"
#import "NSArray+ZLHttpDataProcess.h"
#import "NSDictionary+ZLHttpDataProcess.h"

@implementation ZLHTTPRequestProcess

/**GET请求
 *@param urlString 请求地址
 *@param dict 请求参数
 *@param isAddHeader 是否追加head头，如需增加，请在外界对本类属性httpHeaderM进行配置
 *@param cachePolicy 缓存策略
 *@param complete 处理结果
 *@return Task
 */
- (NSURLSessionDataTask *_Nullable)GET:(NSString *_Nonnull)urlString Params:(NSDictionary *_Nullable)dict AddHttpHeader:(BOOL)isAddHeader CachePolicy:(NSURLRequestCachePolicy)cachePolicy Results:(void (^_Nullable)(ZLHttpErrorState sessionErrorState, id _Nullable responseObject))complete {
    self.requestManager.requestSerializer.cachePolicy = cachePolicy;
    for (NSString *key in self.httpHeaderM.allKeys) {
        if (isAddHeader) {
            [self.requestManager.requestSerializer setValue:self.httpHeaderM[key] forHTTPHeaderField:key];
        }else {
            [self.requestManager.requestSerializer setValue:nil forHTTPHeaderField:key];
        }
    }
    urlString = [urlString rangeOfString:@"http"].location != NSNotFound ? urlString : [NSString stringWithFormat:@"%@%@",self.online ? self.onlinePrefix : self.debugPrefix,urlString];
    __weak typeof(self)weakSelf = self;
    return [self.requestManager GET:urlString parameters:dict headers:self.httpHeaderM progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        //将结果转换为字典
        if ([responseObject isKindOfClass:[NSData class]]) {
            responseObject = [NSJSONSerialization JSONObjectWithData:responseObject options:(NSJSONReadingMutableContainers) error:nil];
        }
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            responseObject = [((NSDictionary *)responseObject) screeningNull];
        }else if ([responseObject isKindOfClass:[NSArray class]]) {
            responseObject = [((NSArray *)responseObject) screeningNull];
        }
        
        //调试打印
        if (weakSelf.showLogs) {
            NSString *message = nil;
            if (responseObject[@"message"]) {
                message = responseObject[@"message"];
            }
            if (responseObject[@"msg"]) {
                message = responseObject[@"msg"];
            }
            NSString *headers = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:weakSelf.requestManager.requestSerializer.HTTPRequestHeaders options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding];
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
        //处理下文
        complete(ZLHttpErrorStateNull, responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        //调试打印
        if (weakSelf.showLogs) {
            NSString *message = @"请求失败";
            NSString *headers = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:weakSelf.requestManager.requestSerializer.HTTPRequestHeaders options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding];
            NSString *params = nil;
            if (dict) {
                params = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding];
            }
            NSString *errorStirng = [[NSString alloc] initWithData:error.userInfo[@"com.alamofire.serialization.response.error.data"] encoding:NSUTF8StringEncoding];
            NSLog(@"\n收到成功后的回执：%@\n\n%@\n%@\n%@\n%@\n%@\n\n\n.", message, urlString, params, headers, errorStirng ,error);
        }
        if ([error.localizedDescription isEqualToString:@"请求超时"]) {
            //超时
            complete(ZLHttpErrorStateTimeout, nil);
        }else {
            //检测网络
            complete((weakSelf.networkStatus == ZLHTTPSessionNetworkStatusNotReachable) ? ZLHttpErrorStateNoNetwork : ZLHttpErrorStateServerFailure, nil);
        }
    }];
}



@end
