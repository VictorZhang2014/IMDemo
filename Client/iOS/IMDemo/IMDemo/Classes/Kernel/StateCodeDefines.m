//
//  StateCodeDefines.c
//  IMDemo
//
//  Created by VictorZhang on 05/07/2017.
//  Copyright © 2017 Victor Studio. All rights reserved.
//

#include "StateCodeDefines.h"


NSString * GetDescFromStateCode(int stateCode)
{
    NSString * stateDesc = @"";
    switch (stateCode) {
        case ErrSocketClosed:
            stateDesc = @"已经与服务器断开连接！";
            break;
        case ErrUnknown:
            stateDesc = @"位置错误";
            break;
        default:
            break;
    }
    return stateDesc;
}


