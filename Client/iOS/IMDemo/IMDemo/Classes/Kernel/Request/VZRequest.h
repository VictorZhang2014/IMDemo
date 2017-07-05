//
//  VZRequest.h
//  IMDemo
//
//  Created by VictorZhang on 04/07/2017.
//  Copyright © 2017 Victor Studio. All rights reserved.
//

#import <Foundation/Foundation.h>


@class VZRequestProtocol;
@class VZRequest;
@class ProtocolBase;

typedef void (^VZRequestBlock)(__kindof VZRequest * request);



@protocol VZRequestDelegate <NSObject>

@required
-(void)onResponse:(ProtocolBase*)response request:(ProtocolBase *)request;

-(void)onError:(int) stateCode description:(NSString *) descr;

@end




@interface VZRequest : NSObject<VZRequestDelegate>

@property (nonatomic, strong) VZRequestProtocol *requestProtocol;
@property (nonatomic, strong) VZRequestProtocol *respondProtocol;

@property (nonatomic, copy) VZRequestBlock completionBlock;
@property (nonatomic, copy) VZRequestBlock failureBlock;

@property (nonatomic, copy) NSString *stateDesc;
@property (nonatomic, assign) int stateCode;

- (void)request;

+ (Class)protocolClass;


@end
