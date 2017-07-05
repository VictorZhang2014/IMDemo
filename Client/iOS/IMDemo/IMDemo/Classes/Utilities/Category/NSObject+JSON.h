//
//  NSObject+JSON.h
//  IMDemo
//
//  Created by VictorZhang on 05/07/2017.
//  Copyright © 2017 Victor Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (JSON)

- (NSDictionary*)packToDict;

-(nonnull id)packJsonDataIncludeReadOnly:(BOOL)readOnly NoNSObject:(BOOL)noObj stopClass:(Class)stopClass;

@end
