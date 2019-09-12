//
//  NSObject+HSRuntime.m
//  HSHUDHelper
//
//  Created by viewat on 16/5/24.
//  Copyright © 2016年 HS. All rights reserved.
//

#import "NSObject+HSRuntime.h"
#import <objc/message.h>
#import <mach-o/dyld.h>
#import <dlfcn.h>

#if defined(__arm64__) || defined(__x86_64__)
extern void hs_switch_block_func();
extern void hs_switch_block_func_stret();
#endif


@implementation NSObject (HSRuntime)

- (void)test {
    NSLog(@"jsii");
}

+ (void)hs_callTrace {
    for (HSMethod *method in self.hs_allMethods) {
        SEL selector = sel_registerName(method.name.UTF8String);
        [self hs_executeBlockOnMethodRun:selector before:^{
            NSLog(@"[%@(%@)\tbefore]", method.name, [self class]);
        } after:^{
            NSLog(@"[%@(%@)\tafter]", method.name, [self class]);
        }];
    }
}

+ (instancetype)shared {
    static NSObject *shared;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
    });
    return shared;
}

- (void)hs_callTrace {
    for (HSMethod *method in self.hs_allMethods) {
        SEL selector = sel_registerName(method.name.UTF8String);
        [self hs_executeBlockOnMethodRun:selector before:^{
            NSLog(@"[%@(%@)\tbefore]", method.name, [self class]);
        } after:^{
            NSLog(@"[%@(%@)\tafter]", method.name, [self class]);
        }];
    }
}

- (SEL)hs_selectorForOriginMethod:(SEL)selector {
    NSString *selectorString = NSStringFromSelector(selector);
    NSString *replaceSelectorName = [NSString stringWithFormat:@"hs_execute_block_%@", selectorString];
    SEL replaceSelector = sel_registerName(replaceSelectorName.UTF8String);
    return replaceSelector;
}


- (void)hs_executeBlockBeforeMethod:(SEL)selector {
    // 执行插入的block
    NSMutableDictionary *executeBlocks = [self hs_executeBlocks];
    NSString *beforeKey = [NSString stringWithFormat:@"%@_before", NSStringFromSelector(selector)];
    void (^executeBlock)() = executeBlocks[beforeKey];
    if (executeBlock) {
        executeBlock();
    }
    
    // 执行全局block
    if (self != [[self class] shared]) {
        [[[self class] shared] hs_executeBlockBeforeMethod:selector];
    }
    
}

- (void)hs_executeBlockAfterMethod:(SEL)selector {
    // 执行插入的block
    NSMutableDictionary *executeBlocks = [self hs_executeBlocks];
    NSString *afterKey = [NSString stringWithFormat:@"%@_after", NSStringFromSelector(selector)];
    void (^executeBlock)() = executeBlocks[afterKey];
    if (executeBlock) {
        executeBlock();
    }
    
    // 执行全局block
    if (self != [[self class] shared]) {
        [[[self class] shared] hs_executeBlockAfterMethod:selector];
    }
}

static char executeBlocksKey;
- (NSMutableDictionary *)hs_executeBlocks {
    
    // 创建一个字典保存所有插入的block
    NSMutableDictionary *blocks = objc_getAssociatedObject(self, &executeBlocksKey);
    if (blocks == nil) {
        blocks = [NSMutableDictionary dictionary];
        objc_setAssociatedObject(self, &executeBlocksKey, blocks, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return blocks;
}

+ (void)hs_executeBlockOnMethodRun:(SEL)originSelector
                            before:(void (^)())before
                             after:(void (^)())after {
    [[self shared] hs_executeBlockOnMethodRun:originSelector before:before after:after];
}

- (void)hs_executeBlockOnMethodRun:(SEL)originSelector
                            before:(void (^)())before
                             after:(void (^)())after {
#if defined(__arm64__) || defined(__x86_64__)
    Class clazz = [self class];
    
    Method originMethod = class_getInstanceMethod(clazz, originSelector);
    IMP implement = method_getImplementation(originMethod);
    
    // 用 Sel 替换成 "hs_execute_block_%@"
    SEL replaceSelector = [self hs_selectorForOriginMethod:originSelector];
    NSString *replaceSelectorName = NSStringFromSelector(replaceSelector);
    
    // 保存要执行的block
    NSString *beforeKey = [NSString stringWithFormat:@"%@_before", replaceSelectorName];
    NSString *afterKey = [NSString stringWithFormat:@"%@_after", replaceSelectorName];
    
    [self hs_executeBlocks][beforeKey] = before;
    [self hs_executeBlocks][afterKey] = after;
    
    // 保存原来的方法 "hs_execute_block_%@"
    if (! [self respondsToSelector:replaceSelector]) {
        class_addMethod([self class], replaceSelector, implement, method_getTypeEncoding(originMethod));
    }
    
    // 替换成后来的方法 "hs_switch_block_func(_stret)"
    IMP replaceImplement = (IMP)hs_switch_block_func;
#if defined(__x86_64__)
    // if a struct with size bigger than 16 will return, set imp to ...stret
    HSMethod *hsmethod = [HSMethod methodWithMethod:originMethod];
    NSMethodSignature *signature = [NSMethodSignature signatureWithObjCTypes:hsmethod.typeEncoding.UTF8String];
    if ([hsmethod.returnType characterAtIndex:0] == '{' &&
        signature.methodReturnLength > 16) {
        replaceImplement = (IMP)hs_switch_block_func_stret;
    }
#endif
    
    method_setImplementation(originMethod, replaceImplement);
    
#else
    NSLog(@"Not support i386 or armv7 yet");
#endif
}

+ (void)hs_swizzleMethod:(SEL)originSelector withMethod:(SEL)replaceSelector {

    Class clazz = [self class];
    
    SEL originSel = originSelector;
    SEL replaceSel = replaceSelector;
    
    Method originMethod = class_getInstanceMethod(clazz, originSel);
    Method replaceMethod = class_getInstanceMethod(clazz, replaceSel);
    
    // 因为现在是两个方法都在同一个类里，所以显得这一步没有必要
    BOOL didAddMethod =
    class_addMethod(clazz,
                    replaceSel,
                    method_getImplementation(replaceMethod),
                    method_getTypeEncoding(replaceMethod));
    
    if (didAddMethod) {
        class_replaceMethod(clazz,
                            replaceSel,
                            method_getImplementation(originMethod),
                            method_getTypeEncoding(originMethod));
    } else {
        method_exchangeImplementations(originMethod, replaceMethod);
    }

}

- (NSArray <HSMethod *>*)hs_allMethods {
    return [[self class] hs_allMethods];
}

+ (NSArray <HSMethod *>*)hs_allMethods {
    NSMutableArray *allMethods = [NSMutableArray array];
    uint methodCount;
    Method *methodList = class_copyMethodList([self class], &methodCount);
    
    for (int i=0; i<methodCount; i++) {
        HSMethod *method = [HSMethod methodWithMethod:methodList[i]];
        [allMethods addObject:method];
    }
    
    free(methodList);
    return allMethods;
}

+ (NSArray <HSIvar *>*)hs_allIvars {
    
    NSMutableArray *ivars = [NSMutableArray array];
    
    uint ivarCount;
    Ivar *ivarList = class_copyIvarList([self class], &ivarCount);
    
    for (int i=0; i<ivarCount; i++) {
        HSIvar *ivar = [HSIvar ivarWithIvar:ivarList[i]];
        [ivars addObject:ivar];
    }
    
    // 取得BOOL，Byte的类型的byteOffset
    [HSIvar fixByteOffsetWithIvars:ivars];
    
    free(ivarList);
    
    return [ivars copy];
}

- (NSArray <HSIvar *>*)hs_allIvars {
    return [[self class] hs_allIvars];
}

+ (NSArray <HSProperty *>*)hs_allProperties {
    
    NSMutableArray *properties = [NSMutableArray array];
    
    uint propertyCount;
    objc_property_t *propertyList = class_copyPropertyList([self class], &propertyCount);
    
    for (int i=0; i<propertyCount; i++) {
        
        HSProperty *property = [HSProperty propertyWithProperty:propertyList[i]];
        [properties addObject:property];
        
    }
    
    free(propertyList);
    
    return [properties copy];
}

- (NSArray<HSProperty *> *)hs_allProperties {
    return [[self class] hs_allProperties];
}

- (NSString *)hs_prettyValuesWithClass:(Class)class  {
    NSMutableString *string = [NSMutableString string];
    NSArray <HSIvar *>*ivars = [class hs_allIvars];
    for (HSIvar *ivar in ivars) {
        [string appendFormat:@"\n%@", [ivar valuePair:self]];
    }
    return [string copy];
}

- (NSString *)hs_prettyValuesWithDepth:(NSInteger)depth  {
    NSMutableString *string = [NSMutableString string];
    
    Class previorClass = nil;
    Class class = [self class];
    NSInteger currentLevel = 0;
    while (class != nil && currentLevel < depth) {
        if (currentLevel != 0) {
            [string appendFormat:@"\n----%@---", class];
        }
        [string appendString:[self hs_prettyValuesWithClass:class]];
        
        currentLevel++;
        previorClass = class;
        class = [class superclass];
    }
    return [string copy];
}

- (NSString *)hs_prettyValues {

    return [self hs_prettyValuesWithDepth:5];
}

+ (void)captureImageAddress {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        LOG(@"archieve file...");
        NSMutableArray<NSString*> *array = [NSMutableArray array];
        uint32_t dyld_image_count = _dyld_image_count();
        for (int i=0; i<dyld_image_count; i++) {
            const char *name = _dyld_get_image_name(i);
            const struct mach_header* header = _dyld_get_image_header(i);
            Dl_info info;
            int ret = dladdr(header, &info);
            [array addObject:[NSString stringWithFormat:@"%p\t(imageName: %s %d)\n", info.dli_fbase, name, ret]];
            
            unsigned int classCount = 0;
            const char ** classes = objc_copyClassNamesForImage(name, &classCount);
            for (int j=0; j<classCount; j++) {
                NSString *className = [NSString stringWithFormat:@"%s", classes[j]];
                //                [array addObject:[NSString stringWithFormat:@"%@(-):\n", className]];
                Class clz = objc_getClass(classes[j]);
                unsigned int methodCount = 0;
                Method *methods = class_copyMethodList(clz, &methodCount);
                for (int k=0; k<methodCount; k++) {
                    IMP imp = method_getImplementation(methods[k]);
                    SEL sel = method_getName(methods[k]);
                    [array addObject:[NSString stringWithFormat:@"%p\t-[%@ %@]\n", imp, className, NSStringFromSelector(sel)]];
                }
                if (methodCount) {
                    free(methods);
                }
                
                //                [array addObject:[NSString stringWithFormat:@"%s(+):\n", classes[j]]];
                Class metaclz = objc_getMetaClass(classes[j]);
                methodCount = 0;
                methods = class_copyMethodList(metaclz, &methodCount);
                for (int k=0; k<methodCount; k++) {
                    IMP imp = method_getImplementation(methods[k]);
                    SEL sel = method_getName(methods[k]);
                    [array addObject:[NSString stringWithFormat:@"%p\t+[%@ %@]\n", imp, className, NSStringFromSelector(sel)]];
                }
                if (methodCount) {
                    free(methods);
                }
            }
            if (classCount) {
                free(classes);
            }
        }
        
        NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/classes.txt"];
        [[[NSFileManager alloc] init] removeItemAtPath:filePath error:nil];
        [[[NSFileManager alloc] init] createFileAtPath:filePath contents:[NSData data] attributes:nil];
        NSFileHandle *fileHandler = [NSFileHandle fileHandleForWritingAtPath:filePath];
        [array enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [fileHandler writeData:[obj dataUsingEncoding:NSUTF8StringEncoding]];
        }];
        LOG(@"archieve file!!!");
        //        LOG(@"%@", array);
    });
}

@end
