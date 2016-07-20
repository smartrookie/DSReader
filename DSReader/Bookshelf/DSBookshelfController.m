//
//  DSBookshelfController.m
//  DSReader
//
//  Created by rookie on 16/6/30.
//  Copyright © 2016年 rookie. All rights reserved.
//

#import "DSBookshelfController.h"
#import "DSListShelfController.h"
#import "DSGridShelfViewController.h"

@interface DSBookshelfController ()
{
    DSListShelfController *_listShelfController;
    DSGridShelfViewController *_gridShelfController;
}

@end

@implementation DSBookshelfController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = @"书架";
        self.tabBarItem.image = [UIImage imageNamed:@""];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    _listShelfController = [DSListShelfController new];
//    _listShelfController.view.bounds = self.view.bounds;
//    [self addChildViewController:_listShelfController];
//    [self.view addSubview:_listShelfController.view];
    
    
    _gridShelfController = [DSGridShelfViewController new];
    _gridShelfController.view.bounds = self.view.bounds;
    [self addChildViewController:_gridShelfController];
    [self.view addSubview:_gridShelfController.view];
    
    
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
