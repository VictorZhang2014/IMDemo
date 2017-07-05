//
//  VZProtocolLogin.h
//  IMDemo
//
//  Created by VictorZhang on 03/07/2017.
//  Copyright © 2017 Victor Studio. All rights reserved.
//

#import "VZRequestProtocol.h"

@interface VZRequestProtocolLogin : VZRequestProtocol

@property (nonatomic, copy) NSString *account;

@property (nonatomic, copy) NSString *password;

@end



@interface VZRespondProtocolLogin : VZRespondProtocol


@end
