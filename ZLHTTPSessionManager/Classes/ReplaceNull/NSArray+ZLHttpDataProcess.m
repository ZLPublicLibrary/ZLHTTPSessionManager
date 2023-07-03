//
//  NSArray+ZLHttpDataProcess.m
//  HTTPSessionManager
//
//  Created by zhaolei on 2018/12/20.
//  Copyright © 2018 赵磊. All rights reserved.
//

#import "NSArray+ZLHttpDataProcess.h"
#import "NSDictionary+ZLHttpDataProcess.h"

@implementation NSArray (ZLHttpDataProcess)

/**
 * 将数组中的Null替换成空字符
 * @param basicDataTypeToString 将基本数据类型转成字符串
 * @return 返回新的没有Null的本类对象
 */
- (NSArray *)screeningNull:(BOOL)basicDataTypeToString {
    NSInteger count = self.count;
    NSMutableArray *objArrayM = [[NSMutableArray alloc]initWithCapacity:count];
    for (NSInteger index = 0; index < count; index++) {
        NSObject *value = self[index];
        if ([value isKindOfClass:[NSNull class]]) {
            [objArrayM addObject:@""];
            continue;
        }
        if ([value isKindOfClass:[NSDictionary class]]) {
            NSMutableDictionary *dictM = (NSMutableDictionary *)[((NSDictionary *)value) screeningNull:basicDataTypeToString];
            [objArrayM addObject:dictM];
            continue;
        }
        if ([value isKindOfClass:[NSArray class]]) {
            NSMutableArray *objArrayM2 = (NSMutableArray *)[((NSArray *)value) screeningNull:basicDataTypeToString];
            [objArrayM addObject:objArrayM2];
            continue;
        }
        if (![value isKindOfClass:[NSString class]] && basicDataTypeToString) {
            [objArrayM addObject:[NSString stringWithFormat:@"%@",value]];
            continue;
        }
        [objArrayM addObject:value];
    }
    return objArrayM;
}

@end
