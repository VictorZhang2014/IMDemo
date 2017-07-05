//
//  VZRequest.m
//  IMDemo
//
//  Created by VictorZhang on 04/07/2017.
//  Copyright © 2017 Victor Studio. All rights reserved.
//

#import "VZRequest.h"
#import "VZRequestProtocol.h"
#import "VZSocketManager.h"

@implementation VZRequest

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        Class ProtocolClass = [[self class] protocolClass];
        if (ProtocolClass) {
            _requestProtocol = [[ProtocolClass alloc] init];
        }
    }
    return self;
}

- (void)request
{
    assert(self.requestProtocol);
    
    [[VZSocketManager shared] sendWithData:self.requestProtocol callback:self];
}

+ (Class)protocolClass
{
    return nil;
}


- (void)onResponse:(ProtocolBase *)response request:(ProtocolBase *)request
{

}

- (void)onError:(int)stateCode description:(NSString *)descr
{
    
}

@end
