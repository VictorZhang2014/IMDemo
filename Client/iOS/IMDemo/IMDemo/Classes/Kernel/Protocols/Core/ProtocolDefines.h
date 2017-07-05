//
//  ProtocolDefines.h
//  IMDemo
//
//  Created by VictorZhang on 04/07/2017.
//  Copyright © 2017 Victor Studio. All rights reserved.
//

#ifndef ProtocolDefines_h
#define ProtocolDefines_h

typedef enum {
    
    PROTOCOL_TYPE_None                  =   0,
    
    PROTOCOL_TYPE_HeartBeats            =   101010,     //心跳
    
    PROTOCOL_TYPE_Login                 =   200001,     //登录

} PROTOCOL_TYPE;

#endif /* ProtocolDefines_h */
