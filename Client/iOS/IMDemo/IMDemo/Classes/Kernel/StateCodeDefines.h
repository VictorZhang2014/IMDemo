//
//  StateCodeDefines.h
//  IMDemo
//
//  Created by VictorZhang on 05/07/2017.
//  Copyright © 2017 Victor Studio. All rights reserved.
//


#define       ErrUnknown                    -1
#define       ErrSocketClosed               -1000










#import <Foundation/Foundation.h>

#define  GET_DESC_OF_STATE_CODE(stateCode)      GetDescFromStateCode(stateCode)

NSString * GetDescFromStateCode(int stateCode);

