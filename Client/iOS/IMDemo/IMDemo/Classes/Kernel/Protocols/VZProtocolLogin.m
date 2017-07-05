//
//  VZProtocolLogin.m
//  IMDemo
//
//  Created by VictorZhang on 03/07/2017.
//  Copyright © 2017 Victor Studio. All rights reserved.
//

#import "VZProtocolLogin.h"

@implementation VZRequestProtocolLogin

- (PROTOCOL_TYPE)protocolType {
    return PROTOCOL_TYPE_Login;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

@end



@implementation VZRespondProtocolLogin

@end
