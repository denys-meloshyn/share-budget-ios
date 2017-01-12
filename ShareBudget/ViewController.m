//
//  ViewController.m
//  ShareBudget
//
//  Created by Denys Meloshyn on 11.01.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

#import "ViewController.h"

#import "UserAPI.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSURLSessionTask *task = [UserAPI update:nil completionBlock:^(id data, NSURLResponse *response, NSError *error) {
        NSLog(@"Response %@ %@ %@", data, response, error);
    }];
    
    [task resume];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
