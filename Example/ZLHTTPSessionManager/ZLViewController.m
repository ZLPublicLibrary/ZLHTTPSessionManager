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
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(request) name:@"ZLHTTPSessionManagerTryRequest" object:nil];
    [self request];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 请求示例
- (void)request {
    [ZLHTTPSessionManager POST:@"/appsys/sitelist.go" Params:nil ModelArray:nil AddHttpHeader:nil CachePolicy:YES Results:^(ZLHttpErrorState sessionErrorState, id  _Nullable responseObject) {

    }];
}

@end
