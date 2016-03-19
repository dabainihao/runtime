//
//  UIAlertView+FSAlterView.m
//  IM
//
//  Created by 杨少锋 on 16/3/2.
//  Copyright © 2016年 杨少锋. All rights reserved.
//

#import "UIAlertView+FSAlterView.h"
#import <objc/runtime.h>
@interface UIAlertView()<UIAlertViewDelegate>
#pragma mark 给分类添加属性
@property (nonatomic, copy) void (^okAction)(NSInteger index);
@property (nonatomic, copy) void (^cancelAction) (NSInteger index);

@end

const void *okActionkey = "okActionkey";
const void *cancelActionKey = "cancelActionKey";


@implementation UIAlertView (FSAlterView)

- (void)setOkAction:(void (^)(NSInteger))okAction {
    // 第一个参数：给哪个对象添加关联
    // 第二个参数：关联的key，通过这个key获取
    // 第三个参数：关联的value
    // 第四个参数:关联的策略
    objc_setAssociatedObject(self, okActionkey, okAction, OBJC_ASSOCIATION_COPY);
}

- (void (^)(NSInteger))okAction {
    // 根据关联的key，获取关联的值。
    return objc_getAssociatedObject(self, okActionkey);
}
- (void (^)(NSInteger))cancelAction {
    return objc_getAssociatedObject(self, cancelActionKey);
}

- (void)setCancelAction:(void (^)(NSInteger))cancelAction {
    objc_setAssociatedObject(self, cancelActionKey, cancelAction, OBJC_ASSOCIATION_COPY);
}

+ (void)showMessage:(NSString *)message a:(id)a button:(NSString *)button otherButton:(NSString *)otherButton buttonAction:(void(^)(NSInteger index))buttonAction otherButtonAction:(void(^)(NSInteger index))otherButonAction {
    UIAlertView *  view = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:message delegate:self cancelButtonTitle:button otherButtonTitles:otherButton , nil];
    view.okAction = buttonAction;
    view.cancelAction = otherButonAction;
    view.delegate = view;
    [view show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) { //取消
        if (self.okAction) {
            self.okAction(buttonIndex);
            self.okAction = nil;
        }
    } else if (buttonIndex == 1) {  //确定
        if (self.cancelAction) {
            self.cancelAction(buttonIndex);
            self.cancelAction = nil;
        }
    }
}

@end
