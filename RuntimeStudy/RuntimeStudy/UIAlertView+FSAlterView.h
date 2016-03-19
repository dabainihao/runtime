//
//  UIAlertView+FSAlterView.h
//  IM
//
//  Created by 杨少锋 on 16/3/2.
//  Copyright © 2016年 杨少锋. All rights reserved.
//  给alterView添加一个分类

#import <UIKit/UIKit.h>

@interface UIAlertView (FSAlterView)

+ (void)showMessage:(NSString *)message a:(id)a button:(NSString *)button otherButton:(NSString *)otherButton buttonAction:(void(^)(NSInteger index))buttonAction otherButtonAction:(void(^)(NSInteger index))otherButonAction;

@end


