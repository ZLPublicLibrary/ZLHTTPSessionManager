//
//  ZLViewController.m
//  ZLHTTPSessionManager
//
//  Created by itzhaolei on 02/19/2021.
//  Copyright (c) 2021 itzhaolei. All rights reserved.
//

#import "ZLViewController.h"
#import <ZLHTTPSessionManager/ZLHTTPSessionHeader.h>

@interface ZLViewController ()

@end

@implementation ZLViewController

- (void)dealloc {
    //移除网络环境发生变化的监听
    ZLChangeNetworkEnvironmentRemoveObserver(self);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //注册网络环境发生变化的监听
    ZLChangeNetworkEnvironmentAddObserver(self, @selector(reloadData));
}

- (void)reloadData {
    //请求参数
    NSMutableDictionary *paramsM = [[NSMutableDictionary alloc] init];
    paramsM[@"key"] = @"value";
    //追加请求头
    [ZLHTTPSessionManager shared].httpHeaderM = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"value",@"key", nil];
    BOOL addHttpHeader = YES;
    //开始请求
    [ZLHTTPSessionManager POST:@"/appsys/sitelist.go" Params:paramsM ModelArray:nil AddHttpHeader:addHttpHeader CachePolicy:NO Results:^(ZLHttpErrorState sessionErrorState, id responseObject) {
        if (!sessionErrorState) {
            if (!sessionErrorState) {
                if (![responseObject[@"code"] intValue]) {
                    //请求成功，进行解析
                    return;
                }
                //服务器返回提示信息进行的报错
                return;
            }
            //网络请求失败的处理
        }
    }];
}

@end
