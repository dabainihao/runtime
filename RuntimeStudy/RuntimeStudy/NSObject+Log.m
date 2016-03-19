//
//  NSObject+Log.m
//  RuntimeStudy
//
//  Created by 杨少锋 on 16/3/18.
//  Copyright © 2016年 杨少锋. All rights reserved.
//

#import "NSObject+Log.h"
#import <objc/runtime.h>

@implementation NSObject (Log)
// 把字典的key值打印成属性
+ (void)resolveDict:(NSDictionary *)dict {
       // 拼接属性字符串代码
    NSMutableString *strM = [NSMutableString string];
    // 1.遍历字典，把字典中的所有key取出来，生成对应的属性代码
    [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        // 类型经常变，抽出来
        NSString *type;
        if ([obj isKindOfClass:NSClassFromString(@"__NSCFString")]) {
            type = @"NSString";
        }else if ([obj isKindOfClass:NSClassFromString(@"__NSCFArray")]){
            type = @"NSArray";
        }else if ([obj isKindOfClass:NSClassFromString(@"__NSCFNumber")]){
            type = @"int";
        }else if ([obj isKindOfClass:NSClassFromString(@"__NSCFDictionary")]){
            type = @"NSDictionary";
        }
        // 属性字符串
        NSString *str;
        if ([type containsString:@"NS"]) {
            str = [NSString stringWithFormat:@"@property (nonatomic, strong) %@ *%@;",type,key];
        }else{
            str = [NSString stringWithFormat:@"@property (nonatomic, assign) %@ %@;",type,key];
        }
        // 每生成属性字符串，就自动换行。
        [strM appendFormat:@"\n%@\n",str];
    }];
    // 把拼接好的字符串打印出来，就好了。
    NSLog(@"%@",strM);
}


+ (instancetype)modelWithDict:(NSDictionary *)dic {
   // Ivar 定义对象的实例变量，包括类型和名字。
    // 创建对应的对象
    id objc = [[self alloc] init];
    // 获取到成员变量,
    unsigned int count;
    // 返回值是ivar数组(里面装着所有的成员属性)  1. 获取那个类的成员属性  2. 这个类有多少个属性,传进去指针,赋值
    Ivar *ivarList = class_copyIvarList(self, &count);
    for (int i = 0; i < count; i++) {
        // 根据下标取出一个成员属性
        Ivar ivar = ivarList[i];
        // 获取属性的类型
        //NSString *properType = [NSString stringWithUTF8String:ivar_getTypeEncoding(ivar)];
        // 获取属性的名
        NSString *propertyName = [NSString stringWithUTF8String:ivar_getName(ivar)];
        // propertyName 中是带_ 的 例如 _name   去掉_
        NSString *key = [propertyName substringFromIndex:1];
        // 根据key值从字典中取出value
        id value = dic[key];
        // 如果value 为字典 , 需要把字典转成对应的模型
        if ([value isKindOfClass:[NSDictionary class]]) {
            // 获取到模型的类对象,调用modelWithDict      modelType = @"类名"
            NSString *modelType = [NSString stringWithUTF8String:ivar_getTypeEncoding(ivar)];   //这个字典对应的模型
            // 生成的是这种@" @\"Women\" " 类型 -》 @"Women"  在OC字符串中 \" -> "，\是转义的意思，不占用字符
            // 裁剪字符串
            NSRange range = [modelType rangeOfString:@"\""];
            modelType = [modelType substringFromIndex:range.location + range.length];
            range = [modelType rangeOfString:@"\""];
            // 裁剪到哪个角标，不包括当前角标
            modelType = [modelType substringToIndex:range.location];
            // 生成对应的类
            Class modelClass = NSClassFromString(modelType);
            if (modelClass) {   // 如果可以获取到模型
                // 把字典转成模型
                value = [modelClass modelWithDict:value];
            }
        }
        // 如果value为数组,数组中装的字典, 需要转成模型数组
        if ([value isKindOfClass:[NSArray class]]) {
            // 必须实现字典转模型的协议,提供数组中装的是什么模型
            if ([self respondsToSelector:@selector(arrayContainModelClass)]) {
                // 获取到数组中装的对应的模型
                NSString *type = [(id)self arrayContainModelClass][key];
                // 生成对应的模型
                Class classModel = NSClassFromString(type);
                // 初始化一个可变数组装转化好的数组
                NSMutableArray *modelArray = [NSMutableArray array];
                for (NSDictionary *item in value) {
                    id model = [classModel modelWithDict:item];
                    [modelArray addObject:model];
                }
                // 把转化好的数组赋值给value
                value = modelArray.copy;
            }
        }
        // 给模型赋值
        if (value) {
            [objc setValue:value forKey:key];
        }
    }
    return objc;
}


@end
