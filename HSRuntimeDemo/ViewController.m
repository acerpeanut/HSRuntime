//
//  ViewController.m
//  HSRuntimeDemo
//
//  Created by viewat on 16/7/4.
//  Copyright © 2016年 HS. All rights reserved.
//

#import "ViewController.h"
#import <HSRuntime/HSRuntime.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self hs_callTrace];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self hello];
    });
}

- (void)hello {
    [self hi];
}
- (void)hi {
    [self peter];
}
- (void)peter {
    
}



@end
