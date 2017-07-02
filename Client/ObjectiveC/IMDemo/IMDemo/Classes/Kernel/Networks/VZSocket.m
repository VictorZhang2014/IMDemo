//
//  VZSocket.m
//  IMDemo
//
//  Created by Victor Zhang on 01/07/2017.
//  Copyright © 2017 Victor Studio. All rights reserved.
//

#import "VZSocket.h"
#include <unistd.h>
#include <netdb.h>
#include <fcntl.h>


#define SOCKET_ERROR -1
#define SOCKET_MAXIMUM_BYTES  2048


@interface VZSocket()
{
    NSString * _host;
    int _port;
    int _socket;
}

@end

@implementation VZSocket

- (instancetype)initWithHost:(NSString *)host port:(int)port
{
    self = [super init];
    if (self) {
        _host = host;
        _port = port;
        
        _sendQueue = [[NSMutableArray<NSData *> alloc] init];
        _recvQueue = [[NSMutableArray<NSData *> alloc] init];
    }
    return self;
}

- (BOOL)connectSocket
{
    [self closeSocket];
    
    int sock = socket(AF_INET, SOCK_STREAM, 0);
    if (sock < 0) {
        _statusCode = VZSocketCreateError;
        NSLog(@"Failed to create Socket!");
        return NO;
    }
    
    struct sockaddr_in addr;
    memset(&addr, 0, sizeof(struct sockaddr_in));
    struct hostent *entr = gethostbyname([_host UTF8String]);
    if (!entr) {
        NSLog(@"socket host is incorrect! \n");
        return NO;
    }
    struct in_addr host;
    memcpy(&host, entr->h_addr, sizeof(struct in_addr));
    addr.sin_addr = host;
    addr.sin_port = htons((u_short)_port);
    addr.sin_family = AF_INET;
    int conn = connect(sock, (struct sockaddr *)&addr, sizeof(struct sockaddr_in));
    if (conn < 0) {
        _statusCode = VZSocketConnectError;
        NSLog(@"Failed to connect to server! \n");
        return NO;
    }
    NSLog(@"Connected to server successfully! \n");
    
    _statusCode = VZSocketConnected;
    int set = 1, sopt = setsockopt(sock, SOL_SOCKET, SO_NOSIGPIPE, (void *)&set, sizeof(int));
    if (sopt < 0) {
        NSLog(@"Failed to set setsockopt() function! \n");
        return NO;
    }
    _socket = sock;
    return YES;
}

- (void)start
{
    [self connectSocket];
    
    //检测是否有发送的消息，一旦有直接发送
    static char * str_sendmsg = "com.victor.longan.queue.send.messages";
    dispatch_queue_t t_sendmsg = dispatch_queue_create(str_sendmsg, DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(t_sendmsg, ^{
        
        while (_statusCode == VZSocketConnected) {
            if (_sendQueue.count > 0) {
                for (NSData * data in _sendQueue) {
                    [self sendData:data];
                }
                @synchronized (self) {
                    [_sendQueue removeAllObjects];
                }
            }
        }
        NSLog(@"Remote Socket has closed, send_message_thread has been closed!");
    });
    
    
    //一直检测接收数据
    static char * str_recvmsg = "com.victor.longan.queue.receive.message";
    dispatch_queue_t t_recvmsg = dispatch_queue_create(str_recvmsg, DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(t_recvmsg, ^{
        
        while (_statusCode == VZSocketConnected) {
            long length = SOCKET_MAXIMUM_BYTES;
            char * buffer = (char *)malloc(SOCKET_MAXIMUM_BYTES);
            [self receiveData:buffer length:length];
            free(buffer);
        }
        NSLog(@"Remote Socket has closed, recv_message_thread has been closed!");
        [self closeSocket];
    });
}

- (void)sendData:(NSData *)data
{
    if (data.length == 0 || !data) return;
    
    ssize_t sent = write(_socket, [data bytes], [data length]);
    
    if (sent > 0) {
        NSLog(@"package sent successfully. ");
    } else if (sent == 0) {
        _statusCode = VZSocketClosed;
        NSLog(@"Remote port has closed when writing.");
    } else if (sent == SOCKET_ERROR){
        _statusCode = VZSocketError;
        NSLog(@"Socket send error when writing.");
    }
}

- (void)receiveData:(void *)data length:(ssize_t)length
{
    ssize_t buflen = read(_socket, data, length);
    
    if (buflen > 0) {
        
        NSData *result = [[NSData alloc] initWithBytes:data length:buflen];
        if (result.length) {
            NSLog(@"Received Data : %@", [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding]);
            
            [_recvQueue addObject:result];
        }
        
    } else if (buflen == 0) {
        _statusCode = VZSocketClosed;
        NSLog(@"Remote port has closed when reading.");
    } else if (buflen == SOCKET_ERROR) {
        _statusCode = VZSocketError;
        NSLog(@"Socket send error when reading");
    }
}

- (void)addMessage:(NSData *)message
{
    @synchronized (self) {
        [_sendQueue addObject:message];
    }
}


/*
- (void)transmit:(const char *)data length:(ssize_t)length
{
    if (length == 0 || data == NULL) return;
    
    ssize_t sentByes = 0;
    ssize_t sent = 0;
    do {
        sent = send(_socket, data, length, 0);
        
        if (sent > 0) {
            sentByes += sent;
            
            if (sentByes == length) {
                NSLog(@"pack sent successfully. ");
            }
        } else if (sent == 0) {
            _statusCode = VZSocketClosed;
            NSLog(@"Remote port has closed.");
            break;
        } else if (sent == SOCKET_ERROR){
            _statusCode = VZSocketError;
            NSLog(@"Socket send error");
            break;
        }
        
    } while (sentByes < length);
}

- (void)receive:(void *)data length:(ssize_t)length
{
    if (length == 0 || data == NULL) return;
    
    ssize_t buflen = 0;
    ssize_t recvBytes = 0;
    do {
        buflen = recv(_socket, data, length, 0);
        recvBytes += buflen;
        
        if (buflen > 0 && buflen < length) {
            
            NSString * result = [[NSString alloc] initWithCString:(const char *)data encoding:NSUTF8StringEncoding];
            NSLog(@"Package has been received successfully. Package is %@", result);
            if (result.length) {
                
                NSString *encryptedStr = [_encryption RSADecryptoString:result];
                [_recvQueue addObject:encryptedStr];
            }
            
        } else if (buflen > 0 && buflen == length) {
            
            
        } else if (buflen == 0) {
            _statusCode = VZSocketClosed;
            NSLog(@"Remote port has closed.");
            break;
        } else if (buflen == SOCKET_ERROR) {
            _statusCode = VZSocketError;
            NSLog(@"Socket send error");
            break;
        }
        
    } while (recvBytes < length);
}

- (void)addMessage:(VLProtocolBase *)protocolBase
{
    [_sendQueue addObject:protocolBase];
}
 */

- (void)closeSocket
{
    _statusCode = VZSocketClosed;
    _socket = -1;
    if (_socket)
        close(_socket);
}

@end
