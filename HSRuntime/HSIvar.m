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

- (NSString *)valuePair:(id)object {
    NSString *type = self.type;
    if ([type rangeOfString:@"@"].location == 0) {
        return [NSString stringWithFormat:@"%@\t:\t%@", self.name, [self valueOfObject:object]];
    }
    void *obj = ( __bridge void *)object;
    char *bytes = (char *)obj;
    
    char character = [type characterAtIndex:0];
    
    if (character == '{') {
        if ([type rangeOfString:@"CGPoint"].location != NSNotFound) {
            return [NSString stringWithFormat:@"%@\t:\t%@", self.name, NSStringFromCGPoint(*((CGPoint *)(bytes+self.offset)))];
        }
        if ([type rangeOfString:@"CGRect"].location != NSNotFound) {
            return [NSString stringWithFormat:@"%@\t:\t%@", self.name, NSStringFromCGRect(*((CGRect *)(bytes+self.offset)))];
        }
        if ([type rangeOfString:@"CGSize"].location != NSNotFound) {
            return [NSString stringWithFormat:@"%@\t:\t%@", self.name, NSStringFromCGSize(*((CGSize *)(bytes+self.offset)))];
        }
        if ([type rangeOfString:@"UIEdgeInsets"].location != NSNotFound) {
            return [NSString stringWithFormat:@"%@\t:\t%@", self.name, NSStringFromUIEdgeInsets(*((UIEdgeInsets *)(bytes+self.offset)))];
        }
        return [NSString stringWithFormat:@"%@\t:\t%@", self.name, [self type]];
    }
    if (character == 'd') {
        return [NSString stringWithFormat:@"%@\t:\t%f", self.name, (double)(bytes[self.offset])];
    }
    if (character == 'Q') {
        return [NSString stringWithFormat:@"%@\t:\t%ld", self.name, (unsigned long)(bytes[self.offset])];
    }
    if (character == 'q') {
        return [NSString stringWithFormat:@"%@\t:\t%ld", self.name, (long)(bytes[self.offset])];
    }
    if (character == 'i') {
        return [NSString stringWithFormat:@"%@\t:\t%d", self.name, (int)(bytes[self.offset])];
    }
    if (character == 'b') {
//        int location = type.length>=2?[type characterAtIndex:1]-'1':0;
        return [NSString stringWithFormat:@"%@\t:\t%d", self.name, (char)(bytes[self.offset+self.byteOffset])];
    }
    if (character == 'B') {
        return [NSString stringWithFormat:@"%@\t:\t%d", self.name, (char)(bytes[self.offset])];
    }
    if (character == 'c') {
        return [NSString stringWithFormat:@"%@\t:\t%d", self.name, (char)(bytes[self.offset])];
    }
    return [NSString stringWithFormat:@"%@\t:\t%@\t%ld", self.name, [self type], (long)self.offset];
}

- (id)valueOfObject:(NSObject *)object {
    Ivar ivar = class_getInstanceVariable([object class], self.name.UTF8String);
    if (ivar) {
        return object_getIvar(object, ivar);
    }
    return nil;
}

- (NSString *)description {
    NSMutableString *description = [NSMutableString string];
    [description appendFormat:@"name: %@, type:%@, offset: %ld", self.name, self.type, (long)self.offset];
    if ([self.type characterAtIndex:0] == 'b') {
        [description appendFormat:@"(%@)", @(self.byteOffset)];
    }
    return [description copy];
}

+ (void)fixByteOffsetWithIvars:(NSArray <HSIvar *>*)ivars {
    NSInteger byteOffset = 0;
    for (HSIvar *ivar in ivars) {
        if ([ivar.type characterAtIndex:0] == 'b') {
            int size = ivar.type.length>=2?[ivar.type characterAtIndex:1]-'1':0;
            ivar.byteOffset = byteOffset;
            byteOffset += size;
        } else {
            byteOffset = 0;
        }
    }
}

@end
