//
//  ZLHTTPSucceedProcess.m
//  HTTPSessionManager
//
//  Created by zhaolei on 2018/12/20.
//  Copyright © 2018 赵磊. All rights reserved.
//

#import "ZLHTTPSucceedProcess.h"
#import "ZLHTTPRequestProcess.h"
#import "NSDictionary+ZLHttpDataProcess.h"
#import "NSArray+ZLHttpDataProcess.h"
#import <AFNetworking/AFNetworking.h>

@implementation ZLHTTPSucceedProcess

/**处理成功结果
 *@param responseObject 成功返回的信息
 *@param manager 请求的管理者
 *@param urlString 请求地址
 *@param dict 请求参数
 *@param results 处理结果
 */
+ (void)disposeResponseWithObject:(id)responseObject Manager:(ZLHTTPRequestProcess *)manager URLString:(NSString *)urlString Params:(NSDictionary *)dict Results:(void (^)(ZLHttpErrorState errorState, id object))results {
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
    if (manager.showLogs) {
        NSString *message = nil;
        if (responseObject[@"message"]) {
            message = responseObject[@"message"];
        }
        if (responseObject[@"msg"]) {
            message = responseObject[@"msg"];
        }
        NSString *headers = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:manager.requestManager.requestSerializer.HTTPRequestHeaders options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding];
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
    results(ZLHttpErrorStateNull, responseObject);
}

@end
