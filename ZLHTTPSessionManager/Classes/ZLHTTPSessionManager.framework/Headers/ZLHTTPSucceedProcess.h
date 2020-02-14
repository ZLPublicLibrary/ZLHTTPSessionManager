//
//  ZLHTTPSucceedProcess.h
//  HTTPSessionManager
//
//  Created by zhaolei on 2018/12/20.
//  Copyright © 2018 赵磊. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZLHTTPSessionManager.h"

@class ZLHTTPRequestProcess;
@interface ZLHTTPSucceedProcess : NSObject

/**处理成功结果
 *@param responseObject 成功返回的信息
 *@param manager 请求的管理者
 *@param urlString 请求地址
 *@param dict 请求参数
 *@param results 处理结果
 */
+ (void)disposeResponseWithObject:(id)responseObject Manager:(ZLHTTPRequestProcess *)manager URLString:(NSString *)urlString Params:(NSDictionary *)dict Results:(void (^)(ZLHttpErrorState errorState, id object))results;

@end
