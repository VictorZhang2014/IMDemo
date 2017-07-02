//
//  ViewController.m
//  IMDemo
//
//  Created by Victor Zhang on 01/07/2017.
//  Copyright © 2017 Victor Studio. All rights reserved.
//

#import "ViewController.h"
#import "VZSocket.h"

@interface ViewController ()

@property (nonatomic, strong) VZSocket *socket;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (!_socket) {
        [self createSocketAndConnect];
    }
    
    if (_socket.statusCode != VZSocketConnected) {
        [self createSocketAndConnect];
    }
    
    NSString *str = @"hello, I am client";
    [_socket addMessage:[str dataUsingEncoding:NSUTF8StringEncoding]];
}

- (void)createSocketAndConnect {
    VZSocket *socket = [[VZSocket alloc] initWithHost:@"192.168.0.103" port:8888];
    [socket start];
    _socket = socket;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
