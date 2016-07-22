//
//  NSObject+HSRuntime.h
//  HSHUDHelper
//
//  Created by viewat on 16/5/24.
//  Copyright © 2016年 HS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import "HSIvar.h"
#import "HSProperty.h"
#import "HSMethod.h"

@interface NSObject (HSRuntime)

+ (void)hs_swizzleMethod:(SEL)originSelector withMethod:(SEL)replaceSelector;

+ (NSArray <HSMethod *>*)hs_allMethods;
- (NSArray <HSMethod *>*)hs_allMethods;
+ (NSArray <HSIvar *>*)hs_allIvars;
- (NSArray <HSIvar *>*)hs_allIvars;
+ (NSArray <HSProperty *>*)hs_allProperties;
- (NSArray <HSProperty *>*)hs_allProperties;

- (void)hs_executeBlockOnMethodRun:(SEL)originSelector
                            before:(void (^)())before
                             after:(void (^)())after;
+ (void)hs_executeBlockOnMethodRun:(SEL)originSelector
                            before:(void (^)())before
                             after:(void (^)())after;

- (void)hs_callTrace;
+ (void)hs_callTrace;

- (NSString *)hs_prettyValues;


@end
