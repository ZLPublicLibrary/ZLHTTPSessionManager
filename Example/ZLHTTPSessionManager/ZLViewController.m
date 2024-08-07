//
//  ZLViewController.m
//  ZLHTTPSessionManager
//
//  Created by itzhaolei on 09/14/2020.
//  Copyright (c) 2020 itzhaolei. All rights reserved.
//

#import "ZLViewController.h"
#import "ZLHTTPSessionHeader.h"

@interface ZLViewController ()

@end

@implementation ZLViewController

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self name:@"ZLHTTPSessionManagerTryRequest" object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.redColor;
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(request) name:@"ZLHTTPSessionManagerTryRequest" object:nil];
    [self request];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 普通请求示例
- (void)request {
    [ZLHTTPSessionManager request:@"/appsys/sitelist.go" httpMethod:post params:nil addHttpHeader:false cachePolicy:false configRequest:nil downloadProgress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nullable error) {
        
    }];
}

@end
