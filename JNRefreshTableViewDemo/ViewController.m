//
//  ViewController.m
//  JNRefreshTableViewDemo
//
//  Created by Yigol on 16/5/12.
//  Copyright © 2016年 Injoinow. All rights reserved.
//

#import "ViewController.h"
#import "RefreshViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"RefreshDemo";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    RefreshViewController *vv  =  segue.destinationViewController;
    if ([segue.identifier isEqualToString:@"aaa"]) {
        vv.isHaveData = YES;
    } else {
        vv.isHaveData = NO;
    }
    
}

@end
