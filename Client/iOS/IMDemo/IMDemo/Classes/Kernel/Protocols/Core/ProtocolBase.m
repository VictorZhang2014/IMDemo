//
//  ProtocolBase.m
//  IMDemo
//
//  Created by VictorZhang on 03/07/2017.
//  Copyright © 2017 Victor Studio. All rights reserved.
//

#import "ProtocolBase.h"
#import "NSDictionary+JSON.h"
#import "NSData+gzip.h"



@interface ProtocolBase()
{
    int indexTag;
}

@end

@implementation ProtocolBase

- (instancetype)init
{
    self = [super init];
    if (self) {
        _packingData = [[NSMutableData alloc] init];
    }
    return self;
}

- (void)initPackageHeader
{
    _header.vzTag[0] = 'V';
    _header.vzTag[1] = 'Z';
    _header.vzTag[2] = 'D';
    _header.vzTag[3] = 'M';
    
    _header.ptclVersion = 1;
    _header.ptclEncrypt = 1;
    _header.ptclCmpreType = 1;
    _header.bodyFormat = 1;
    _header.statusCode = 0;
    
    _header.time = (UInt64)([[NSDate date] timeIntervalSince1970] * 1000);
}

- (void)pack {
    [self initPackageHeader];
    
    NSMutableData *packageBodyData = [[NSMutableData alloc] init];
    NSDictionary *jsonData = self.body;
    NSString *bodyStr = [jsonData JSONRepresentation];
    
    if (bodyStr.length > 256) {
        _header.ptclCmpreType = 2;
        NSData *dataString = [[NSData alloc] initWithData:[bodyStr dataUsingEncoding:NSUTF8StringEncoding]];
        NSData *dataCompress = [dataString compress];
        
        
        [packageBodyData appendData:dataCompress];
    } else {
        NSData *dataString = [[NSData alloc] initWithData:[bodyStr dataUsingEncoding:NSUTF8StringEncoding]];
        
        [packageBodyData appendData:dataString];
    }
    
    _header.packageSize = (UInt32)[packageBodyData length] + 27;
    [self packHeader];
    [self.packingData appendData:packageBodyData];
    
    indexTag = 0;
}


- (void)setPackageHeader:(UInt32)ptclType msgAction:(UInt8)msgAction
{
    _header.ptclType = ptclType;
    _header.msgAction = msgAction;
}


- (void)packHeader
{
    [self packUInt32:_header.packageSize];
    [self packUInt8:_header.vzTag[0]];
    [self packUInt8:_header.vzTag[1]];
    [self packUInt8:_header.vzTag[2]];
    [self packUInt8:_header.vzTag[3]];
    [self packUInt8:_header.ptclVersion];
    [self packUInt8:_header.ptclEncrypt];
    [self packUInt8:_header.ptclCmpreType];
    [self packUInt8:_header.msgAction];
    [self packUInt8:_header.bodyFormat];
    [self packUInt64:_header.time];
    [self packUInt16:_header.statusCode];
    [self packUInt32:_header.ptclType];
}

- (void)packUInt64:(UInt64)int64
{
    NSData *intData = [NSData dataWithBytes:&int64 length:8];
    [_packingData appendData:[intData subdataWithRange:NSMakeRange(7, 1)]];
    [_packingData appendData:[intData subdataWithRange:NSMakeRange(6, 1)]];
    [_packingData appendData:[intData subdataWithRange:NSMakeRange(5, 1)]];
    [_packingData appendData:[intData subdataWithRange:NSMakeRange(4, 1)]];
    [_packingData appendData:[intData subdataWithRange:NSMakeRange(3, 1)]];
    [_packingData appendData:[intData subdataWithRange:NSMakeRange(2, 1)]];
    [_packingData appendData:[intData subdataWithRange:NSMakeRange(1, 1)]];
    [_packingData appendData:[intData subdataWithRange:NSMakeRange(0, 1)]];
    indexTag += 8;
}

- (void)packUInt32:(UInt32)int32
{
    NSData *intData = [NSData dataWithBytes:&int32 length:4];
    [_packingData appendData:[intData subdataWithRange:NSMakeRange(3, 1)]];
    [_packingData appendData:[intData subdataWithRange:NSMakeRange(2, 1)]];
    [_packingData appendData:[intData subdataWithRange:NSMakeRange(1, 1)]];
    [_packingData appendData:[intData subdataWithRange:NSMakeRange(0, 1)]];
    indexTag += 4;
}

- (void)packUInt16:(UInt16)int16
{
    NSData *intData = [NSData dataWithBytes:&int16 length:2];
    [_packingData appendData:[intData subdataWithRange:NSMakeRange(1, 1)]];
    [_packingData appendData:[intData subdataWithRange:NSMakeRange(0, 1)]];
    indexTag += 2;
}

- (void)packUInt8:(UInt8)int8
{
    [_packingData appendBytes:&int8 length:1];
    indexTag += 1;
}

/*
- (UInt64)popInt64
{
    int digit = 8;
    UInt64 reInt=0;
    if (indexTag+digit<=parseDatalength)
    {
        NSData *dataTmp = [parseData subdataWithRange:NSMakeRange(indexTag, digit)];
        NSMutableData *convertData = [[NSMutableData alloc] init];
        [convertData appendData:[dataTmp subdataWithRange:NSMakeRange(7, 1)]];
        [convertData appendData:[dataTmp subdataWithRange:NSMakeRange(6, 1)]];
        [convertData appendData:[dataTmp subdataWithRange:NSMakeRange(5, 1)]];
        [convertData appendData:[dataTmp subdataWithRange:NSMakeRange(4, 1)]];
        [convertData appendData:[dataTmp subdataWithRange:NSMakeRange(3, 1)]];
        [convertData appendData:[dataTmp subdataWithRange:NSMakeRange(2, 1)]];
        [convertData appendData:[dataTmp subdataWithRange:NSMakeRange(1, 1)]];
        [convertData appendData:[dataTmp subdataWithRange:NSMakeRange(0, 1)]];
        [convertData getBytes:&reInt];
        //LxInfoLog(LxFrameWorkModule,  @"  reInt is %d",reInt);
        indexTag +=digit;
    }
    return reInt;
}

- (UInt32)popInt32
{
    int digit = 4;
    UInt32 reInt=0;
    if (indexTag+digit<=parseDatalength)
    {
        NSData *dataTmp = [parseData subdataWithRange:NSMakeRange(indexTag, digit)];
        NSMutableData *convertData = [[NSMutableData alloc] init];
        [convertData appendData:[dataTmp subdataWithRange:NSMakeRange(3, 1)]];
        [convertData appendData:[dataTmp subdataWithRange:NSMakeRange(2, 1)]];
        [convertData appendData:[dataTmp subdataWithRange:NSMakeRange(1, 1)]];
        [convertData appendData:[dataTmp subdataWithRange:NSMakeRange(0, 1)]];
        [convertData getBytes:&reInt];
        //LxInfoLog(LxFrameWorkModule,  @"  reInt is %d",reInt);
        indexTag +=digit;
    }
    return reInt;
}

- (UInt16)popInt16
{
    int digit = 2;
    UInt16 reInt=0;
    if (indexTag+digit<=parseDatalength)
    {
        NSData *dataTmp = [parseData subdataWithRange:NSMakeRange(indexTag, digit)];
        NSMutableData *convertData = [[NSMutableData alloc] init];
        [convertData appendData:[dataTmp subdataWithRange:NSMakeRange(1, 1)]];
        [convertData appendData:[dataTmp subdataWithRange:NSMakeRange(0, 1)]];
        [convertData getBytes:&reInt];
        //LxInfoLog(LxFrameWorkModule,  @"  reInt is %d",reInt);
        indexTag +=digit;
    }
    return reInt;
}

- (UInt8)popInt8
{
    int digit = 1;
    UInt8 reInt=0;
    if (indexTag+digit<=parseDatalength)
    {
        NSData *dataTmp = [parseData subdataWithRange:NSMakeRange(indexTag, digit)];
        [dataTmp getBytes:&reInt];
        //LxInfoLog(LxFrameWorkModule,  @"  reInt is %d",reInt);
        indexTag +=digit;
    }
    return reInt;
}
*/


@end
