//
//  HSProperty.m
//  HSHUDHelper
//
//  Created by viewat on 16/5/26.
//  Copyright © 2016年 HS. All rights reserved.
//


#import "HSProperty.h"

@implementation HSProperty

+ (instancetype)propertyWithProperty:(objc_property_t)property {
    HSProperty *myProperty = [[self alloc] init];
    
    const char *propertyName = property_getName(property);
    
    uint attributeCount;
    objc_property_attribute_t *attributeList = property_copyAttributeList(property, &attributeCount);
    
    NSMutableArray *attributes = [NSMutableArray array];
    for (int j=0; j<attributeCount; j++) {

        HSAttribute *myAttribute = [HSAttribute attributeWithAttribute:attributeList[j]];
        [attributes addObject:myAttribute];
    }
    myProperty.name = [NSString stringWithUTF8String:propertyName];
    myProperty.attributes = [attributes copy];
    
//    free(propertyName);
    free(attributeList);
    
    return myProperty;
}

- (NSString *)description {
    NSMutableString *description = [NSMutableString string];
    [description appendFormat:@"name: %@, attributes:%@", self.name, self.attributes];
    return [description copy];
}

@end
