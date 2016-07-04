//
//  HSAttribute.h
//  HSHUDHelper
//
//  Created by viewat on 16/5/26.
//  Copyright © 2016年 HS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface HSAttribute : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *value;

+ (instancetype)attributeWithAttribute:(objc_property_attribute_t)attribute;

@end
