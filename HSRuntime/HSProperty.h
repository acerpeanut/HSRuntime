//
//  HSProperty.h
//  HSHUDHelper
//
//  Created by viewat on 16/5/26.
//  Copyright © 2016年 HS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import "HSAttribute.h"

@interface HSProperty : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSArray <HSAttribute *>*attributes;

+ (instancetype)propertyWithProperty:(objc_property_t)property;

@end
