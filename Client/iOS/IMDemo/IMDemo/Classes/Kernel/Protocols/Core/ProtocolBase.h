//
//  ProtocolBase.h
//  IMDemo
//
//  Created by VictorZhang on 03/07/2017.
//  Copyright © 2017 Victor Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProtocolDefines.h"

//定义包头的结构体
typedef struct {
    char   vzTag[4];         //“VZDM”
    UInt8 ptclVersion;       //协议的版本号 1
    UInt8  ptclEncrypt;      //加密类型, 1:不加密  2:加密
    UInt8  ptclCmpreType;    //压缩类型, 1:不压缩  2:gzip
    UInt8  bodyFormat;       //消息内容格式类型, 1:JSON 2:xml
    UInt16 statusCode;       //响应消息中针对请求中消息头信息的问题给出的状态码，请求消息中此字段直接填 0 即可。
    UInt64 time;             //表示自 1970 年 1 月 1 日以来的毫秒数
    
    UInt32 packageSize;      //包的总长度
    UInt32 ptclType;         //协议ID
    UInt8  msgAction;        //消息的动作指向类型,  1:请求（request） 2:	响应（response）
} PACKAGE_HEADER;


@interface ProtocolBase : NSObject
{
    PACKAGE_HEADER _header;
}

@property (nonatomic, copy) NSString *sessionId;

@property (nonatomic, strong) NSDictionary *body; //各个协议的内容
@property (nonatomic, strong) NSMutableData *packingData; //包头 + 协议 的总

- (void)pack;

- (void)setPackageHeader:(UInt32)ptclType msgAction:(UInt8)msgAction;


@end
