//
//  VZSettings.m
//  IMDemo
//
//  Created by VictorZhang on 04/07/2017.
//  Copyright © 2017 Victor Studio. All rights reserved.
//

#import "VZSettings.h"

@implementation VZSettings

+ (instancetype)shared {
    static VZSettings *_settings = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _settings = [[VZSettings alloc] init];
    });
    return _settings;
}

@end
