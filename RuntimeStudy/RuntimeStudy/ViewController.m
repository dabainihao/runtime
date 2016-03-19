//
//  ViewController.m
//  RuntimeStudy
//
//  Created by 杨少锋 on 16/3/18.
//  Copyright © 2016年 杨少锋. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"
#import "Women.h"
#import "UIImage+LoadImage.h"
#import "NSObject+Log.h"
#import <objc/runtime.h>

@interface ViewController ()

@end

void reportFunction() {
    
}

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *view = [[UIView alloc] init];
    NSDictionary *dic = [NSDictionary dictionaryWithObject:@[@"1",@"2",@"3"] forKey:@"women"];
    //[NSObject resolveDict:dic];
    //NSLog(@"%@",dic);
    Person *person = [Person modelWithDict:dic];
    NSLog(@"%@",person.women);
    
}

// 消息机制
- (void)sendMessage {
    Person *person = [Person new];
    // 发送消息
    //[person eat];
    // 发送消息(相当于[person eat])
    objc_msgSend(person, @selector(eat));
}

// 添加一个方法
- (void)addMethod {
    Person *person = [Person new];
    [person performSelector:@selector(happy) withObject:nil];
}

// 方法交换
- (void)mathExchang {
    UIImage *Image = [UIImage imageNamed:@"2"];
}

// 动态的创建一个类
- (void)creatClass {
    // 创建一个类CustomView是UIView的子类,为这个类分配空间
    Class newClass = objc_allocateClassPair([UIView class], "CustomView", 0);
    //  为这个类添加一个方法
    class_addMethod(newClass, @selector(report), (IMP)reportFunction, "V@:");
    // 注册这个类 , 让这个类可以使用
    objc_registerClassPair(newClass);
    // 创建一个CustomView实例
    id custom = [[newClass alloc] init];
    // 调用一个方法
    [custom performSelector:@selector(report) withObject:nil];
}

@end
