//
//  DSPageViewController.m
//  DSReader
//
//  Created by rookie on 16/6/30.
//  Copyright © 2016年 rookie. All rights reserved.
//

#import "DSPageViewsController.h"
#import "UIColor+ds.h"
#import "DSTextPageView.h"
#import "DSEpubPageView.h"

@interface DSPageViewsController ()<UIPageViewControllerDelegate,UIPageViewControllerDataSource>
{
}

@property (nonatomic) EpubModel *epuModel;

@end

@implementation DSPageViewsController

- (instancetype)initEpubModel:(EpubModel *)model
{
    self = [self init];
    _epuModel = model;
    return self;
}

- (instancetype)init
{
    
    NSDictionary *options =[NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:UIPageViewControllerSpineLocationMin]
                                                       forKey: UIPageViewControllerOptionSpineLocationKey];
    self = [self initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:options];
    if (self) {
        
    }
    [self setHidesBottomBarWhenPushed:YES];
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;
    self.dataSource = self;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    DSEpubPageView *pageView = [[DSEpubPageView alloc] initWithModel:_epuModel];
    [self setViewControllers:@[pageView] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    
}

- (void)middleZoneTapAction:(id)sender
{
    Boolean isHidden = self.navigationController.navigationBar.isHidden;
    [self.navigationController setNavigationBarHidden:!isHidden animated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}








#pragma mark - UIPageViewControllerDelegate

//- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers
//{
//    
//}
//
//- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed
//{
//    
//}

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    DSEpubPageView *oldPageView = (DSEpubPageView *)viewController;
    NSInteger oldPageIndex = oldPageView.pageIndex;
    
    DSEpubPageView *newPageView = [[DSEpubPageView alloc] initWithModel:_epuModel];
    newPageView.pageIndex = oldPageIndex;
    
    return  newPageView;
}

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    DSEpubPageView *oldPageView = (DSEpubPageView *)viewController;
    NSInteger oldPageIndex = oldPageView.pageIndex;
    
    DSEpubPageView *newPageView = [[DSEpubPageView alloc] initWithModel:_epuModel];
    newPageView.pageIndex = oldPageIndex;
    
    return  newPageView;
}

@end
