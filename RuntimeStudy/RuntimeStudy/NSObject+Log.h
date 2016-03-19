//
//  NSObject+Log.h
//  RuntimeStudy
//
//  Created by 杨少锋 on 16/3/18.
//  Copyright © 2016年 杨少锋. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NSObjectDelegate <NSObject>

- (NSDictionary *)arrayContainModelClass;

@end

@interface NSObject (Log)

// 获取key字典的key值,并获取类型
+ (void)resolveDict:(NSDictionary *)dict;

+ (instancetype)modelWithDict:(NSDictionary *)dic;

@end
