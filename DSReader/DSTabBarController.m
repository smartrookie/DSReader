//
//  DSTabBarController.m
//  DSReader
//
//  Created by rookie on 16/6/30.
//  Copyright © 2016年 rookie. All rights reserved.
//

#import "DSTabBarController.h"
#import "DSNavigationController.h"
#import "DSPageViewController.h"

@implementation DSTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    DSPageViewController *pageCtrl = [DSPageViewController new];
    DSNavigationController *navi = [[DSNavigationController alloc] initWithRootViewController:pageCtrl];
    
    [self addChildViewController:navi];
}

@end