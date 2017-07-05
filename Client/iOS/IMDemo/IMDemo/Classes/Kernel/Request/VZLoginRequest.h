//
//  VZLoginRequest.h
//  IMDemo
//
//  Created by VictorZhang on 04/07/2017.
//  Copyright © 2017 Victor Studio. All rights reserved.
//

#import "VZRequest.h"

@interface VZLoginRequest : VZRequest

- (instancetype)initWithAccount:(NSString *)account password:(NSString *)password;

@end
