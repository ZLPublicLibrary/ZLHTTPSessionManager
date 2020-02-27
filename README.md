### 简介
基于AFNetworking的马甲库

---
### 作用
    - 日志打印
    - 筛除NULL
    - 检测网络状态
    - 将ERROR进行分类    
    - 转换基本数据类型为字符串
---
### 安装
```
pod 'ZLHTTPSessionManager'
```
---
### 使用
- 头文件
```
#import <ZLHTTPSessionManager.h>
```
- AppDelegate配置
```
    //配置基本信息
    [ZLHTTPSessionManager configDebugUrlPrefix:@"调试环境前缀" OnlineUrlPrefix:@"发布环境前缀" Online:NO ShowLogs:YES NetworkState:^(ZLHTTPSessionNetworkStatus state) {
       //网络状态改变后的回调
    }];
```
- GET
```
    //参数
    NSMutableDictionary *dictM = [NSMutableDictionary new];
    dictM[@"key"] = @"value";
    
    [ZLHTTPSessionManager GET:@"路径" Params:dictM AddHttpHeader:NO CachePolicy:YES Results:^(ZLHttpErrorState sessionErrorState, id responseObject) {
        ///处理结果
    }];
```
- POST
```
    //参数
    NSMutableDictionary *dictM = [NSMutableDictionary new];
    dictM[@"key"] = @"value";
    
    [ZLHTTPSessionManager POST:@"路径" Params:dictM ModelArray:nil AddHttpHeader:NO CachePolicy:YES Results:^(ZLHttpErrorState sessionErrorState, id responseObject) {
        ///处理结果
    }];
```

---
### 重大迭代跟踪
`~> 1.0.0` 首次发布版本，功能已完善。
`~> 1.0.1` 修复因bitcode无法导入的问题；
`~> 1.0.2` 适配低版本的CPU架构。

---
### FAQ
- 搜索不到？
    - 终端执行
    ```rm ~/Library/Caches/CocoaPods/search_index.json```
    - 重新```pod search ZLHTTPSessionManager```
- 安装失败？
    - 查看你的当前项目的podfile里是否已经安装了AFNetworking，如果有，请将它删除，然后重试。
