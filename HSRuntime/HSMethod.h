//
//  HSMethod.h
//  HSHUDHelper
//
//  Created by viewat on 16/5/31.
//  Copyright © 2016年 HS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface HSMethod : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *returnType;
@property (nonatomic, copy) NSString *argumentType;
@property (nonatomic, copy) NSString *typeEncoding;
@property (nonatomic, assign) NSInteger argumentCount;

+ (instancetype)methodWithMethod:(Method)method;

@end
