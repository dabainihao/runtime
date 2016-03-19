//
//  Person.h
//  RuntimeStudy
//
//  Created by 杨少锋 on 16/3/18.
//  Copyright © 2016年 杨少锋. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Women.h"

@interface Person : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) Women *women;
@property (nonatomic, copy) NSArray *arr;
- (void)eat;


@end
