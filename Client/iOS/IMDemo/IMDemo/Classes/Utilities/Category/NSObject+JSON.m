//
//  NSObject+JSON.m
//  IMDemo
//
//  Created by VictorZhang on 05/07/2017.
//  Copyright © 2017 Victor Studio. All rights reserved.
//

#import "NSObject+JSON.h"
#import <objc/runtime.h>

@implementation NSObject (JSON)



- (NSDictionary*)packToDict
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    unsigned int propsCount;
    objc_property_t *properties = class_copyPropertyList([self class], &propsCount);//获得属性列表
    for(int i = 0;i < propsCount; i++)
    {
        objc_property_t property = properties[i];
        
        NSString *propName = [NSString stringWithUTF8String:property_getName(property)];//获得属性的名称
        id value = [self valueForKey:propName];//kvc 获得属性的值
        if(!value) {
            value = [NSNull null];
        } else {
            value = [self getObjectInternal:value];//自定义处理数组，字典，其他类
        }
        [dic setObject:value forKey:propName];
    }
    return dic;
}

- (id)getObjectInternal:(id)obj
{
    if([obj isKindOfClass:[NSString class]] || [obj isKindOfClass:[NSNumber class]] || [obj isKindOfClass:[NSNull class]]) {
        return obj;
    }
    
    if([obj isKindOfClass:[NSArray class]])
    {
        NSArray *objarr = obj;
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:objarr.count];
        for(int i = 0;i < objarr.count; i++)
        {
            [arr setObject:[self getObjectInternal:[objarr objectAtIndex:i]] atIndexedSubscript:i];
        }
        return arr;
    }
    
    if([obj isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *objdic = obj;
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:[objdic count]];
        for(NSString *key in objdic.allKeys)
        {
            [dic setObject:[self getObjectInternal:[objdic objectForKey:key]] forKey:key];
        }
        return dic;
    }
    return [self packToDict];
}








-(nonnull id)packJsonData
{
    return [self packJsonDataIncludeReadOnly:YES NoNSObject:YES stopClass:[NSObject class]];
}

-(nonnull id)packJsonDataIncludeReadOnly:(BOOL)readOnly NoNSObject:(BOOL)noObj stopClass:(Class)stopClass
{
    NSMutableDictionary *propertyData = [NSMutableDictionary dictionary];
    Class selfClass = [self class];
    while (selfClass != stopClass && selfClass != [NSObject class]) {
        unsigned int outCount, i;
        BOOL packAllPropertyAutomatic = ![selfClass implementationToSelector:@selector(keyForProperty:)];
        objc_property_t *properties = class_copyPropertyList(selfClass, &outCount);
        for (i = 0; i<outCount; i++)
        {
            objc_property_t property = properties[i];
            if (!readOnly) {
                char *valueChar = property_copyAttributeValue(property, "R");
                if (valueChar != NULL) {
                    free(valueChar);
                    continue;
                }
                else free(valueChar);
            }
            if (!noObj) {
                char *valueChar = property_copyAttributeValue(property, "T");
                if (*valueChar != '@') {
                    free(valueChar);
                    continue;
                }
                else free(valueChar);
            }
            //            LxInfoLog(LxFrameWorkModule,  @"%s %s\n", property_getName(property), property_getAttributes(property));
            
            const char* char_f =property_getName(property);
            NSString *propertyName = [NSString stringWithUTF8String:char_f];
            if (packAllPropertyAutomatic) {
                id propertyValue = [self valueForKey:(NSString *)propertyName];
                if (propertyValue) {
                    [propertyData setObject:[propertyValue packJsonData] forKey:propertyName];
                }
            }
            else {
                NSString* key = [selfClass keyForProperty:propertyName];
                if (key) {
                    id propertyValue = [self valueForKey:(NSString *)propertyName];
                    if (propertyValue) {
                        [propertyData setObject:[propertyValue packJsonData] forKey:key];
                    }
                }
            }
        }
        free(properties);
        selfClass = [selfClass superclass];
    }
    return propertyData;
}

+(NSString*) keyForProperty:(NSString*)objKey
{
    return objKey;
}

+(BOOL) implementationToSelector:(nonnull SEL)aSelector
{
    unsigned int outCount;
    Method *list = class_copyMethodList(object_getClass([self class]), &outCount);
    for (int i = 0; i < outCount; i++) {
        Method method = list[i];
        if (method_getName(method) == aSelector) {
            free(list);
            return YES;
        }
    }
    free(list);
    return NO;
}

@end





