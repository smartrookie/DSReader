//
//  DSPageViewController.m
//  DSReader
//
//  Created by rookie on 16/6/30.
//  Copyright © 2016年 rookie. All rights reserved.
//

#import "DSPageViewController.h"

@interface DSPageViewController ()<UIPageViewControllerDelegate,UIPageViewControllerDataSource>

@end

@implementation DSPageViewController

- (instancetype)init
{
    
    NSDictionary *options =[NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:UIPageViewControllerSpineLocationMin]
                                                       forKey: UIPageViewControllerOptionSpineLocationKey];
    self = [self initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:options];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;
    self.dataSource = self;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    UIViewController *vctrl = [UIViewController new];
    vctrl.view.backgroundColor = [UIColor redColor];
    
    [self setViewControllers:@[vctrl] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    
    
    
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}








#pragma mark - UIPageViewControllerDelegate

- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers
{
    
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed
{
    
}

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    UIViewController *vctrl = [UIViewController new];
    vctrl.view.backgroundColor = [UIColor redColor];
    return  vctrl;
}

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    UIViewController *vctrl = [UIViewController new];
    vctrl.view.backgroundColor = [UIColor redColor];
    return  vctrl;
}


@end
