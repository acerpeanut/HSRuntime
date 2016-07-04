//
//  HSAttribute.m
//  HSHUDHelper
//
//  Created by viewat on 16/5/26.
//  Copyright © 2016年 HS. All rights reserved.
//

#import "HSAttribute.h"

@implementation HSAttribute

+ (instancetype)attributeWithAttribute:(objc_property_attribute_t)attribute {
    HSAttribute *myAttribute = [[self alloc] init];
    myAttribute.name = [NSString stringWithUTF8String:attribute.name];
    myAttribute.value = [NSString stringWithUTF8String:attribute.value];
    return myAttribute;
}

- (NSString *)description {
    NSMutableString *description = [NSMutableString string];
    [description appendFormat:@"name: %@, value:%@", self.name, self.value];
    return [description copy];
}
@end
