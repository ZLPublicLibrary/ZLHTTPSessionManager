//
//  ZLHTTPErrorProcess.h
//  HTTPSessionManager
//
//  Created by zhaolei on 2018/12/20.
//  Copyright © 2018 赵磊. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZLHTTPSessionManager.h"

NS_ASSUME_NONNULL_BEGIN

@class ZLHTTPRequestProcess;
@interface ZLHTTPErrorProcess : NSObject

/**处理错误
 *@param error 错误信息
 *@param manager 请求的管理者
 *@param urlString 请求地址
 *@param dict 请求参数
 *@param complete 处理结果
 */
+ (void)disposeErrorWithError:(NSError *)error Manager:(ZLHTTPRequestProcess *)manager URLString:(NSString *)urlString Params:(NSDictionary *)dict Results:(void (^)(ZLHttpErrorState errorState))complete;

@end

NS_ASSUME_NONNULL_END
