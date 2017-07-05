//
//  VZRequestProtocol.m
//  IMDemo
//
//  Created by VictorZhang on 04/07/2017.
//  Copyright © 2017 Victor Studio. All rights reserved.
//

#import "VZRequestProtocol.h"
#import "VZSettings.h"
#import "NSObject+JSON.h"

@implementation VZRequestProtocol

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setPackageHeader:[self protocolType] msgAction:1];
    }
    return self;
}

- (PROTOCOL_TYPE)protocolType {
    return PROTOCOL_TYPE_None;
}

- (void)pack
{
    if (!self.body) {
        NSDictionary* data = [self packToDict];
        NSMutableDictionary *dicData = [NSMutableDictionary dictionaryWithObjectsAndKeys:SETTINGS.sessionId,@"sessionId", nil];
        [dicData addEntriesFromDictionary:data];
        self.body = dicData;
    }
    [super pack];
}

@end





@implementation VZRespondProtocol

@end

