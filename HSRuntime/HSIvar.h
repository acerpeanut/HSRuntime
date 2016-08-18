//
//  HSIvar.h
//  HSHUDHelper
//
//  Created by viewat on 16/5/26.
//  Copyright © 2016年 HS. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface HSIvar : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, assign) NSInteger offset;

@property (nonatomic, assign) Ivar ivar;

+ (instancetype)ivarWithIvar:(Ivar)ivar;
- (id)valueOfObject:(NSObject *)object;
- (NSString *)valuePair:(id)object;

/** ivar的offset未必是真实的偏移量，当类型为b1时，它
 *  自身的偏移量还需再加上byteOffset
 */
@property (nonatomic, assign) NSInteger byteOffset;

+ (void)fixByteOffsetWithIvars:(NSArray <HSIvar *>*)ivars;
@end
