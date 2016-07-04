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
    
    [self hs_executeBlock:^{
        NSLog(@"called when viewWillAppear finish");
    } onMethodRun:@selector(viewWillAppear:)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"run viewWillAppear");
}



@end
