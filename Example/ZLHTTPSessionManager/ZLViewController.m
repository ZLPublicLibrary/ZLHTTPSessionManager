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

- (void)viewDidLoad
{
    [super viewDidLoad];
	[ZLHTTPSessionManager POST:@"https://api.91tumi.com/appsys/sitelist.go" Params:nil ModelArray:nil AddHttpHeader:nil CachePolicy:YES Results:^(ZLHttpErrorState sessionErrorState, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
