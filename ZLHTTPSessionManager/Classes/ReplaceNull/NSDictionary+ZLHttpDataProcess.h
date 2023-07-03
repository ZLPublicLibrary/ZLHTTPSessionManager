//
//  NSDictionary+ZLHttpDataProcess.h
//  HTTPSessionManager
//
//  Created by zhaolei on 2018/12/20.
//  Copyright © 2018 赵磊. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (ZLHttpDataProcess)

/**将字典中的Null替换成空字符
 * @param basicDataTypeToString 将基本数据类型转成字符串
 *@return 返回新的没有Null的本类对象
 */
- (instancetype)screeningNull:(BOOL)basicDataTypeToString;

@end

NS_ASSUME_NONNULL_END
