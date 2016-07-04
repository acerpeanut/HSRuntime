//
//  HSIvar.m
//  HSHUDHelper
//
//  Created by viewat on 16/5/26.
//  Copyright © 2016年 HS. All rights reserved.
//

#import "HSIvar.h"

@implementation HSIvar

+ (instancetype)ivarWithIvar:(Ivar)ivar {
    HSIvar *myIvar = [[self alloc] init];
    const char *ivarName = ivar_getName(ivar);
    const char *ivarType = ivar_getTypeEncoding(ivar);
    ptrdiff_t ivarOffset = ivar_getOffset(ivar);
    
    myIvar.name = [NSString stringWithUTF8String:ivarName];
    myIvar.type = [NSString stringWithUTF8String:ivarType];
    myIvar.offset = ivarOffset;
    myIvar.ivar = ivar;
    
    return myIvar;
}

- (NSString *)description {
    NSMutableString *description = [NSMutableString string];
    [description appendFormat:@"name: %@, type:%@, offset: %ld", self.name, self.type, (long)self.offset];
    return [description copy];
}

@end
