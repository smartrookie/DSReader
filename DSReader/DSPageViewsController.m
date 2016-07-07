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
#import "DSEpubConfig.h"

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
    return self;
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
    NSInteger oldChapterIndex   = oldPageView.chapterIndex;
    NSInteger oldPageNum        = oldPageView.pageNum;
    NSInteger oldPageCount      = oldPageView.pageCount;
    
    //正常翻页
    if (oldPageNum < oldPageCount) {
        DSEpubPageView *newPageView = [[DSEpubPageView alloc] initWithModel:_epuModel];
        newPageView.chapterIndex = oldChapterIndex;
        newPageView.pageNum      = oldPageNum + 1;
        return newPageView;
    }
    //换章
    else if (oldChapterIndex < _epuModel.pageRefs.count) {
        DSEpubPageView *newPageView = [[DSEpubPageView alloc] initWithModel:_epuModel];
        newPageView.chapterIndex = oldChapterIndex + 1;
        newPageView.pageNum      = 0;
        return newPageView;
    }
    else {
        return nil;
    }
}

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    DSEpubPageView *oldPageView = (DSEpubPageView *)viewController;
    NSInteger oldChapterIndex   = oldPageView.chapterIndex;
    NSInteger oldPageNum        = oldPageView.pageNum;
    
    if (oldChapterIndex == 0) return nil;
    
    //正常翻页
    if (oldPageNum >= 0) {
        DSEpubPageView *newPageView = [[DSEpubPageView alloc] initWithModel:_epuModel];
        newPageView.chapterIndex = oldChapterIndex;
        newPageView.pageNum      = oldPageNum - 1;
        return newPageView;
    }
    else {
        DSEpubPageView *newPageView = [[DSEpubPageView alloc] initWithModel:_epuModel];
        newPageView.chapterIndex = oldChapterIndex;
        newPageView.pageNum      = -1;
        return newPageView;
    }
}




























@end
