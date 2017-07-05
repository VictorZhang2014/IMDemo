//
//  VZSocketManager.m
//  IMDemo
//
//  Created by VictorZhang on 04/07/2017.
//  Copyright © 2017 Victor Studio. All rights reserved.
//

#import "VZSocketManager.h"
#import "VZSocket.h"
#import "ProtocolBase.h"
#import "VZRequest.h"
#import "StateCodeDefines.h"


#define VZ_HOST @"10.18.138.27"
#define VZ_PORT 8888




@interface WaitingTask : NSObject
@property (nonatomic, strong) ProtocolBase* data;
@property (nonatomic, strong) id<VZRequestDelegate> callback;
@end

@implementation WaitingTask

- (instancetype)initWithData:(ProtocolBase *)data callback:(id<VZRequestDelegate>)callback
{
    self = [super init];
    if (self) {
        _data = data;
        _callback = callback;
    }
    return self;
}

@end












@interface VZSocketManager()<VZSocketDelegate>

@property (nonatomic, strong) VZSocket *sock;

@property (nonatomic, strong) NSMutableArray<WaitingTask *> *waitingTasks;

@end

@implementation VZSocketManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        _waitingTasks = [[NSMutableArray alloc] init];
        
        _sock = [[VZSocket alloc] initWithHost:VZ_HOST port:VZ_PORT];
        _sock.delegate = self;
        [_sock start];
    }
    return self;
}

+ (instancetype)shared
{
    static VZSocketManager * _socketManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _socketManager = [[VZSocketManager alloc] init];
    });
    return _socketManager;
}

- (void)sendWithData:(ProtocolBase *)requestProtocol callback:(id<VZRequestDelegate>)callback
{
    @synchronized (self.waitingTasks) {
        [self.waitingTasks addObject:[[WaitingTask alloc] initWithData:requestProtocol callback:callback]];
    }
    
    [self triggerRun];
}

- (void)triggerRun
{
    if(_sock) {
        if (_sock.statusCode == VZSocketConnected) {
            @synchronized(_waitingTasks) {
                for(WaitingTask *task in self.waitingTasks) {
                    [self sendPackage:task];
                }
                [self.waitingTasks removeAllObjects];
            }
        }

    }
}

/**
 *发送协议包
 */
-(void)sendPackage:(WaitingTask *)task
{
    if (_sock.statusCode == VZSocketConnected) {
        
        [task.data pack];
        [_sock addMessage:task.data.packingData];
        
    } else if (_sock.statusCode == VZSocketClosed) {
        [task.callback onError:ErrSocketClosed description:GET_DESC_OF_STATE_CODE(ErrSocketClosed)];
    } else {
        [task.callback onError:ErrUnknown description:GET_DESC_OF_STATE_CODE(ErrUnknown)];
    }
}


#pragma mark - VZSocketDelegate
- (void)socket:(VZSocket *)socketInstance readData:(NSData *)data
{
    NSLog(@"Received Data : %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
}

@end
