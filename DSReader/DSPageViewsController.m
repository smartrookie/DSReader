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
#import "DSPopoverSettingsViewController.h"

@interface DSPageViewsController ()<UIPageViewControllerDelegate,UIPageViewControllerDataSource,DSEpubPageViewTapDelegate,UIPopoverPresentationControllerDelegate>
{
}

@property (nonatomic) EpubModel *epuModel;
@property (nonatomic, getter=isTopBarHidden, assign) BOOL topBarHidden;

@property (strong, nonatomic) DSEpubPageView *installPageView;

@end

@implementation DSPageViewsController

- (instancetype)initEpubModel:(EpubModel *)model
{
    self = [self init];
    _epuModel = model;
    return self;
}
- (instancetype)initEpubModel:(EpubModel *)model andDSEpubPageView:(DSEpubPageView *)pageView
{
    self = [self initEpubModel:model];
    _installPageView = pageView;
    return self;
}

- (DSEpubPageView *)currentPageView
{
    return self.viewControllers[0];
}

- (instancetype)init
{
    
    NSDictionary *options =[NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:UIPageViewControllerSpineLocationMin]
                                                       forKey: UIPageViewControllerOptionSpineLocationKey];
    
    if ([[DSEpubConfig shareInstance] browseModel] == DSPageBrowseModel_Page)
    {
        self = [self initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl
                       navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                     options:options];
    }
    else
    {
        self = [self initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                       navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                     options:options];
    }
    if (self)
    {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.delegate = self;
    self.dataSource = self;
    self.view.backgroundColor = [UIColor whiteColor];
    
    DSEpubPageView *pageView;
    if (!_installPageView)
    {
        pageView = [[DSEpubPageView alloc] initWithModel:_epuModel];
        pageView.pageNum = 0;
        pageView.chapterIndex = 0;
    }
    else
    {
        pageView = _installPageView;
    }
    pageView.tapDelegate = self;
    [self setViewControllers:@[pageView] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
}

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller traitCollection:(UITraitCollection *)traitCollection {
    return UIModalPresentationPopover; // 20
}

- (UIViewController *)presentationController:(UIPresentationController *)controller viewControllerForAdaptivePresentationStyle:(UIModalPresentationStyle)style {
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller.presentedViewController];
    return navController; // 21
}

- (void)setTopBarHidden:(BOOL)hidden
{
    if (_topBarHidden == hidden) return;
    _topBarHidden = hidden;
    [self.navigationController setNavigationBarHidden:hidden animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:hidden withAnimation:UIStatusBarAnimationSlide];
    [self.navigationController setToolbarHidden:hidden animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - DSEpubPageViewTapDelegate

- (void)pageView:(__unused DSEpubPageView *)epubPageView tapPosition:(Tap_Position)position
{
    if (!_topBarHidden) {
        [self setTopBarHidden:YES];
        return;
    }
    
    switch (position) {
        case Tap_Left:
            NSLog(@"Left");
            [self pageUpAction];
            break;
        case Tap_Center:
            NSLog(@"Center");
            
            [self setTopBarHidden:!self.isTopBarHidden];

            break;
        case Tap_Right:
            NSLog(@"Right");
            [self pageDownAction];
            break;
    }
}
// 上一页
- (void)pageUpAction
{
    DSEpubPageView *newPageView = [self pagePreController];
    if (newPageView) {
        [self setViewControllers:@[newPageView] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
    }
}
// 下一页
- (void)pageDownAction
{
    DSEpubPageView *newPageView = [self pageNextController];
    if (newPageView) {
        [self setViewControllers:@[newPageView] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    }
}

// 下一页
- (DSEpubPageView *)pageNextController
{
    DSEpubPageView *oldPageView = (DSEpubPageView *)self.viewControllers[0];
    NSInteger oldChapterIndex   = oldPageView.chapterIndex;
    NSInteger oldPageNum        = oldPageView.pageNum;
    NSInteger oldPageCount      = oldPageView.pageCount;
    
    DSEpubPageView *_newPageView;
    
    //正常翻页
    if (oldPageNum < oldPageCount - 1) {
        DSEpubPageView *newPageView = [[DSEpubPageView alloc] initWithModel:_epuModel];
        newPageView.chapterIndex = oldChapterIndex;
        newPageView.pageNum      = oldPageNum + 1;
        _newPageView = newPageView;
        newPageView.tapDelegate = self;
    }
    //换章
    else if (oldChapterIndex < _epuModel.pageRefs.count - 1) {
        DSEpubPageView *newPageView = [[DSEpubPageView alloc] initWithModel:_epuModel];
        newPageView.chapterIndex = oldChapterIndex + 1;
        newPageView.pageNum      = 0;
        _newPageView = newPageView;
        newPageView.tapDelegate = self;
    }
    return _newPageView;
}

// 上一页
- (DSEpubPageView *)pagePreController
{
    DSEpubPageView *oldPageView = (DSEpubPageView *)self.viewControllers[0];
    NSInteger oldChapterIndex   = oldPageView.chapterIndex;
    NSInteger oldPageNum        = oldPageView.pageNum;
    
    DSEpubPageView *_newPageView;
    
    if (oldChapterIndex <= 0) return nil;
    
    //正常翻页
    if (oldPageNum > 0) {
        DSEpubPageView *newPageView = [[DSEpubPageView alloc] initWithModel:_epuModel];
        newPageView.chapterIndex = oldChapterIndex;
        newPageView.pageNum      = oldPageNum - 1;
        _newPageView = newPageView;
        newPageView.tapDelegate = self;
    }
    //换章
    else {
        DSEpubPageView *newPageView = [[DSEpubPageView alloc] initWithModel:_epuModel];
        newPageView.chapterIndex = oldChapterIndex - 1;
        newPageView.pageNum      = -1;
        _newPageView = newPageView;
        newPageView.tapDelegate = self;
    }
    
    return _newPageView;
}



#pragma mark - UIPageViewControllerDelegate

- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers
{
    [self setTopBarHidden:YES];
}
//
//- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed
//{
//}

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    return [self pagePreController];
}

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    return [self pageNextController];
}






























@end
