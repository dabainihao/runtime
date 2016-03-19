//
//  Person.m
//  RuntimeStudy
//
//  Created by 杨少锋 on 16/3/18.
//  Copyright © 2016年 杨少锋. All rights reserved.
//

#import "Person.h"
#import <objc/runtime.h>

void happy() {
    NSLog(@"添加高兴的方法");
}

@implementation Person

- (void)eat {
    NSLog(@"男人吃糖");
}

#pragma mark 添加一个方法
// 添加方法实现 (当一个静态方法找不到实现的时候,会走这个方法)
+ (BOOL)resolveInstanceMethod:(SEL)sel {
    // SEL方法选择器。SEL其主要作用是快速的通过方法名字（makeText）查找到对应方法的函数指针，然后调用其函 数。SEL其本身是一个Int类型的一个地址，地址中存放着方法的名字。对于一个类中。每一个方法对应着一个SEL。所以iOS类中不能存在2个名称相同 的方法，即使参数类型不同，因为SEL是根据方法名字生成的，相同的方法名称只能对应一个SEL
    if (sel == @selector(happy)) {
        // 第一个参数：给哪个类添加方法
        // 第二个参数：添加方法的方法编号
        // 第三个参数：添加方法的函数实现（函数地址）
        // 第四个参数：函数的类型，(返回值+参数类型) v:void @:对象->self :表示SEL->_cmd
        class_addMethod([self class], sel, (IMP)happy, "V@:");
    }
    return [super resolveInstanceMethod:sel];
}

// 当一个类方法找不到实现的时候会走这个方法
+ (BOOL)resolveClassMethod:(SEL)sel {
    return [super resolveClassMethod:sel];
}

#pragma mark


@end
