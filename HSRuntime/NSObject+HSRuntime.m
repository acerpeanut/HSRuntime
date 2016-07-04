//
//  NSObject+HSRuntime.m
//  HSHUDHelper
//
//  Created by viewat on 16/5/24.
//  Copyright © 2016年 HS. All rights reserved.
//

#import "NSObject+HSRuntime.h"
#import <objc/message.h>

#if defined(__arm64__) || defined(__x86_64__)
extern void hs_switch_block_func();
extern void hs_switch_block_func_stret();
#endif


@implementation NSObject (HSRuntime)



- (SEL)hs_selectorForOriginMethod:(SEL)selector {
    NSString *selectorString = NSStringFromSelector(selector);
    NSString *replaceSelectorName = [NSString stringWithFormat:@"hs_execute_block_%@", selectorString];
    SEL replaceSelector = sel_registerName(replaceSelectorName.UTF8String);
    return replaceSelector;
}


- (void)hs_executeBlockForOriginSelector:(SEL)selector {
    // 执行插入的block
    NSMutableDictionary *executeBlocks = [self hs_executeBlocks];
    void (^executeBlock)() = executeBlocks[NSStringFromSelector(selector)];
    if (executeBlock) {
        executeBlock();
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

- (void)hs_executeBlock:(void (^)())block onMethodRun:(SEL)originSelector {
#if defined(__arm64__) || defined(__x86_64__)
    Class clazz = [self class];
    
    Method originMethod = class_getInstanceMethod(clazz, originSelector);
    IMP implement = method_getImplementation(originMethod);
    
    // 用 "hs_execute_block_%@"方法 保存原来的方法
    SEL replaceSelector = [self hs_selectorForOriginMethod:originSelector];
    NSString *replaceSelectorName = NSStringFromSelector(replaceSelector);
    
    [self hs_executeBlocks][replaceSelectorName] = block;
    

    if (! [self respondsToSelector:replaceSelector]) {
        class_addMethod([self class], replaceSelector, implement, method_getTypeEncoding(originMethod));
    }
  
    IMP replaceImplement = (IMP)hs_switch_block_func;
#if defined(__x86_64__)
    // if a struct with size bigger than 16 will return, set to ...stret
    HSMethod *hsmethod = [HSMethod methodWithMethod:originMethod];
    NSMethodSignature *signature = [NSMethodSignature signatureWithObjCTypes:hsmethod.typeEncoding.UTF8String];
    if ([hsmethod.returnType characterAtIndex:0] == '{' &&
        signature.methodReturnLength > 16) {
        replaceImplement = (IMP)hs_switch_block_func_stret;
    }
#endif

    method_setImplementation(originMethod, replaceImplement);
    
#else
#warning "Not support i386 or armv7 yet"
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

- (id)hs_ivarValue:(NSString *)ivarName {
    Ivar ivar = class_getInstanceVariable([self class], ivarName.UTF8String);
    if (ivar) {
        return object_getIvar(self, ivar);
    }
    return nil;
  
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

@end
