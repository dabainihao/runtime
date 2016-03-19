//
//  UIImage+LoadImage.m
//  RuntimeStudy
//
//  Created by 杨少锋 on 16/3/18.
//  Copyright © 2016年 杨少锋. All rights reserved.
//

#import "UIImage+LoadImage.h"
#import <objc/runtime.h>

@implementation UIImage (LoadImage)

// 加载分类到内存的时候调用
+ (void)load {
    // 获取到imageName方法的地址
    Method imageName = class_getClassMethod(self, @selector(imageNamed:));
    // 获取到imageWithName方法的地址
    Method imageWithName = class_getClassMethod(self, @selector(imageWithName:));
    // 交换两个方法的地址
    method_exchangeImplementations(imageName, imageWithName);
}

//不能在分类中重写系统方法imageNamed，因为会把系统的功能给覆盖掉，而且分类中不能调用super.
+ (instancetype)imageWithName:(NSString *)name {
    UIImage *image = [UIImage imageWithName:name];
    if (image == nil) {
        NSLog(@"你的图片地址为空");
    }
    return image;
}


@end
