//
//  HSMethod.m
//  HSHUDHelper
//
//  Created by viewat on 16/5/31.
//  Copyright © 2016年 HS. All rights reserved.
//

#import "HSMethod.h"

@implementation HSMethod

+ (instancetype)methodWithMethod:(Method)method {
    HSMethod *myMethod = [[HSMethod alloc] init];
    
    SEL methodSelector = method_getName(method);
    myMethod.name = NSStringFromSelector(methodSelector);
    myMethod.argumentCount = method_getNumberOfArguments(method);
    
    char tmp[1000] = {0};
    method_getReturnType(method, tmp, 1000);
    myMethod.returnType = [NSString stringWithUTF8String:tmp];
    
    method_getArgumentType(method, 0, tmp, 1000);
    myMethod.argumentType = [NSString stringWithUTF8String:tmp];
    
    const char *typeEncoding = method_getTypeEncoding(method);
    myMethod.typeEncoding = [NSString stringWithUTF8String:typeEncoding];
    
//    method_getDescription(<#Method m#>);

    return myMethod;
}

- (NSString *)description {
    NSMutableString *description = [NSMutableString string];
    [description appendFormat:@"method: %@", self.name];
    return [description copy];
}
@end
