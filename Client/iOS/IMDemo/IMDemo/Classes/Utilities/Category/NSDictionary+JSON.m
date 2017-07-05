//
//  NSDictionary+JSON.m
//  IMDemo
//
//  Created by VictorZhang on 05/07/2017.
//  Copyright © 2017 Victor Studio. All rights reserved.
//

#import "NSDictionary+JSON.h"

@implementation NSDictionary (JSON)

- (NSString *)JSONRepresentation
{
    NSData *jsonData = [self toJSONData];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString;
}

- (NSData *)toJSONData
{
    __autoreleasing NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self
                                                       options:0//NSJSONWritingPrettyPrinted
                                                         error:&error];
    if ([jsonData length] > 0 && error == nil)
    {
        return jsonData;
    }
    else
    {
        return nil;
    }
}


@end
