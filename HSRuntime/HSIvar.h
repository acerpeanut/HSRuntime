//
//  HSIvar.h
//  HSHUDHelper
//
//  Created by viewat on 16/5/26.
//  Copyright © 2016年 HS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface HSIvar : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, assign) NSInteger offset;

@property (nonatomic, assign) Ivar ivar;

+ (instancetype)ivarWithIvar:(Ivar)ivar;

@end
