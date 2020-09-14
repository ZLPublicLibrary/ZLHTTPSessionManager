//
//  ZLFileModel.h
//  BulgeSeekUserPort
//
//  Created by zhaolei on 2018/8/21.
//  Copyright © 2018年 赵磊. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZLHTTPFileModel : NSObject

///图片
@property (nonatomic,strong) UIImage *fileImage;
///文件二进制
@property (nonatomic,strong) NSData *fileData;
///文件沙盒路径
@property (nonatomic,strong) NSString *filePath;
///文件类型
@property (nonatomic,strong) NSString *fileType;
///文件名称（上传时根据需要传入）
@property (nonatomic,strong) NSString *fileName;

@end
