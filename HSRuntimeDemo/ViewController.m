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

typedef struct {
    long y;
    long y1;
} node;

node returnCGRect() {
    node x = {30,40};
    return x;
}
void doReturn() {
    node x = returnCGRect();
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self hs_executeBlockOnMethodRun:@selector(viewWillAppear:) before:^{
        NSLog(@"viewWillAppear: - before");
    } after:^{
        NSLog(@"viewWillAppear: - after");
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"run viewWillAppear");
}



@end
