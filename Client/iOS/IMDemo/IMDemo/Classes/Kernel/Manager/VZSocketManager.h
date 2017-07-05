//
//  VZSocketManager.h
//  IMDemo
//
//  Created by VictorZhang on 04/07/2017.
//  Copyright © 2017 Victor Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ProtocolBase;
@protocol VZRequestDelegate;

@interface VZSocketManager : NSObject

+ (instancetype)shared;

- (void)sendWithData:(ProtocolBase *)requestProtocol callback:(id<VZRequestDelegate>)callback;

@end
