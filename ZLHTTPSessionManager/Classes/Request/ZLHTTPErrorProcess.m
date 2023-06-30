//
//  ZLHTTPErrorProcess.m
//  HTTPSessionManager
//
//  Created by zhaolei on 2018/12/20.
//  Copyright © 2018 赵磊. All rights reserved.
//

#import "ZLHTTPErrorProcess.h"
#import "ZLHTTPRequestProcess.h"
#import "AFNetworking/AFNetworking.h"

@implementation ZLHTTPErrorProcess

/**处理错误
 *@param error 错误信息
 *@param manager 请求的管理者
 *@param urlString 请求地址
 *@param dict 请求参数
 *@param complete 处理结果
 */
+ (void)disposeErrorWithError:(NSError *)error Manager:(ZLHTTPRequestProcess *)manager URLString:(NSString *)urlString Params:(NSDictionary *)dict Results:(void (^)(ZLHttpErrorState errorState))complete {
    //调试打印
    if (manager.showLogs) {
        NSString *message = @"请求失败";
        NSString *headers = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:manager.requestManager.requestSerializer.HTTPRequestHeaders options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding];
        NSString *params = nil;
        if (dict) {
            params = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding];
        }
        NSString *errorStirng = [[NSString alloc] initWithData:error.userInfo[@"com.alamofire.serialization.response.error.data"] encoding:NSUTF8StringEncoding];
        NSLog(@"\n收到成功后的回执：%@\n\n%@\n%@\n%@\n%@\n%@\n\n\n.", message, urlString, params, headers, errorStirng ,error);
    }
    if ([error.localizedDescription isEqualToString:@"请求超时"]) {
        //超时
        complete(ZLHttpErrorStateTimeout);
    }else {
        //检测网络
        complete((manager.networkStatus == ZLHTTPSessionNetworkStatusNotReachable) ? ZLHttpErrorStateNoNetwork : ZLHttpErrorStateServerFailure);
    }
    
}

@end
