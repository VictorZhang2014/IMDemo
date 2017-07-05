//
//  VZSocket.h
//  IMDemo
//
//  Created by VictorZhang on 03/07/2017.
//  Copyright © 2017 Victor Studio. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum {
    VZSocketConnected               = 0,
    
    VZSocketError                   = -1,
    VZSocketConnectError            = 1,
    VZSocketCreateError             = 2,
    VZSocketClosed                  = 3,
} VZSocketStatusCode;



@class VZSocket;
@protocol VZSocketDelegate <NSObject>

- (void)socket:(VZSocket *)socketInstance readData:(NSData *)data;

@end




@interface VZSocket : NSObject
{
    NSMutableArray<NSData *> * _sendQueue;
}

@property (nonatomic, weak) id<VZSocketDelegate> delegate;

@property (nonatomic, assign) VZSocketStatusCode statusCode;

- (instancetype)initWithHost:(NSString *)host port:(int)port;

- (void)start;

- (void)addMessage:(NSData *)message;

@end
