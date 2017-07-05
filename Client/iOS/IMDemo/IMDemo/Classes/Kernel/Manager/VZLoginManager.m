//
//  VZLoginManager.m
//  IMDemo
//
//  Created by VictorZhang on 04/07/2017.
//  Copyright © 2017 Victor Studio. All rights reserved.
//

#import "VZLoginManager.h"
#import "VZLoginRequest.h"


@implementation VZLoginManager

+ (void)loginWithAccount:(NSString *)account password:(NSString *)password completion:(void(^)(NSInteger stateCode, NSString* stateDesc))completion
{
    VZLoginRequest *request = [[VZLoginRequest alloc] initWithAccount:account password:password];
    if (completion) {
        [request setCompletionBlock:^(VZLoginRequest *req) {
            completion(req.stateCode, req.stateDesc);
        }];
        [request setFailureBlock:^(VZLoginRequest *req) {
            completion(req.stateCode, req.stateDesc);
        }];
    }
    [request request];
}

@end
