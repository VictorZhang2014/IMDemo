//
//  VZLoginManager.h
//  IMDemo
//
//  Created by VictorZhang on 04/07/2017.
//  Copyright © 2017 Victor Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VZLoginManager : NSObject

+ (void)loginWithAccount:(NSString *)account password:(NSString *)password completion:(void(^)(NSInteger stateCode, NSString* stateDesc))completion;

@end
