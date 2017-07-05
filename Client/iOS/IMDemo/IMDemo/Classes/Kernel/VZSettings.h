//
//  VZSettings.h
//  IMDemo
//
//  Created by VictorZhang on 04/07/2017.
//  Copyright © 2017 Victor Studio. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface VZSettings : NSObject

+ (instancetype)shared;

/* 
 * 每次和服务器建立起连接后，服务器会返回一个sessionId，然后每次发送数据时，要携带此sessionId
 */
@property (nonatomic, copy) NSString *sessionId;

@end




#define SETTINGS  [VZSettings shared]
