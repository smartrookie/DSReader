//
//  DSTabBarController.m
//  DSReader
//
//  Created by rookie on 16/6/30.
//  Copyright © 2016年 rookie. All rights reserved.
//

#import "DSTabBarController.h"
#import "DSNavigationController.h"
#import "DSBookshelfController.h"
#import "PersonalCenterViewController.h"

@implementation DSTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    DSBookshelfController *pageCtrl = [DSBookshelfController new];
    DSNavigationController *naviPage = [[DSNavigationController alloc] initWithRootViewController:pageCtrl];
    
    PersonalCenterViewController *person = [PersonalCenterViewController new];
    DSNavigationController *naviPerson = [[DSNavigationController alloc] initWithRootViewController:person];
    person.tabBarItem.selectedImage = [UIImage imageNamed:@"TabIconContacts_Highlighted"];
    person.tabBarItem.image = [UIImage imageNamed:@"TabIconContacts"];
    
    [self addChildViewController:naviPage];
    [self addChildViewController:naviPerson];
    
}

@end
