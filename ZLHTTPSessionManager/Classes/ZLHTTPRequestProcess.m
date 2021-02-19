//
//  ZLHTTPRequestProcess.m
//  HTTPSessionManager
//
//  Created by zhaolei on 2018/12/20.
//  Copyright © 2018 赵磊. All rights reserved.
//

#import "ZLHTTPRequestProcess.h"
#import "ZLHTTPSucceedProcess.h"
#import "ZLHTTPErrorProcess.h"

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
    return [self.requestManager GET:urlString parameters:dict headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [ZLHTTPSucceedProcess disposeResponseWithObject:responseObject Manager:weakSelf URLString:urlString Params:dict Results:^(ZLHttpErrorState errorState, id object) {
            complete(errorState,object);
            return;
        }];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [ZLHTTPErrorProcess disposeErrorWithError:error Manager:weakSelf URLString:urlString Params:dict Results:^(ZLHttpErrorState errorState) {
            complete(errorState,nil);
        }];
    }];
}

/**POST请求 --  追加图片数据
 *@param urlString 请求地址
 *@param dict 请求参数
 *@param isAddHeader 是否追加head头，如需增加，请在外界对本类属性httpHeaderM进行配置
 *@param cachePolicy 缓存策略
 *@param complete 处理结果
 *@return Task
 */
- (NSURLSessionDataTask *_Nullable)POST:(NSString *_Nonnull)urlString Params:(NSDictionary *_Nullable)dict ModelArray:(NSArray <ZLHTTPFileModel *>*_Nullable)modelArray AddHttpHeader:(BOOL)isAddHeader CachePolicy:(NSURLRequestCachePolicy)cachePolicy Results:(void (^_Nullable)(ZLHttpErrorState sessionErrorState, id _Nullable responseObject))complete {
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
    return [self.requestManager POST:urlString parameters:dict headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        if (modelArray.count) {
            for (NSInteger a = 0; a < modelArray.count; a++) {
                ZLHTTPFileModel *fileModel = modelArray[a];
                [formData appendPartWithFileData:fileModel.fileData name:fileModel.fileName fileName:fileModel.filePath mimeType:fileModel.fileType];
            }
        }
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [ZLHTTPSucceedProcess disposeResponseWithObject:responseObject Manager:weakSelf URLString:urlString Params:dict Results:^(ZLHttpErrorState errorState, id object) {
            complete(errorState,object);
            return;
        }];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [ZLHTTPErrorProcess disposeErrorWithError:error Manager:weakSelf URLString:urlString Params:dict Results:^(ZLHttpErrorState errorState) {
            complete(errorState,nil);
        }];
    }];
}

@end
