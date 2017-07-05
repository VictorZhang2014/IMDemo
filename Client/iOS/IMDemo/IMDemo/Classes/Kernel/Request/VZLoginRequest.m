//
//  VZLoginRequest.m
//  IMDemo
//
//  Created by VictorZhang on 04/07/2017.
//  Copyright © 2017 Victor Studio. All rights reserved.
//

#import "VZLoginRequest.h"
#import "VZProtocolLogin.h"

@implementation VZLoginRequest

+ (Class)protocolClass
{
    return [VZRequestProtocolLogin class];
}

- (instancetype)initWithAccount:(NSString *)account password:(NSString *)password
{
    self = [super init];
    if (self) {
        VZRequestProtocolLogin *protocol = (VZRequestProtocolLogin *)self.requestProtocol;
        if (protocol) {
            protocol.account = account;
            protocol.password = password;
        }
    }
    return self;
}

@end
