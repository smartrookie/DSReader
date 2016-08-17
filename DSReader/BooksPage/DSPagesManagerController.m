//
//  DSPagesManagerController.m
//  DSReader
//
//  Created by rookie on 16/8/9.
//  Copyright © 2016年 rookie. All rights reserved.
//

#import "DSPagesManagerController.h"
#import "DSPopoverSettingsViewController.h"
#import "DSPageViewsController.h"
#import "DSEpubConfig.h"
#import "DSCatalogViewController.h"
#import "DSEpubPageView.h"

@interface DSPagesManagerController ()

@property (strong, nonatomic) EpubModel *epubModel;
@property (strong, nonatomic) DSPageViewsController *pageViewController;
@property (strong, nonatomic) DSCatalogViewController *catalogViewController;


@property (strong, nonatomic) UIBarButtonItem *cateItem;
@property (assign, nonatomic) BOOL            showCatalog;

@end

@implementation DSPagesManagerController

- (instancetype)initEpubModel:(EpubModel *)epub
{
    self = [self init];
    _epubModel = epub;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _pageViewController = [[DSPageViewsController alloc] initEpubModel:_epubModel];
    
    [self.view addSubview:_pageViewController.view];
    [self addChildViewController:_pageViewController];
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"NavigationBackArrowNormal"]
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(backAction:)];
    
    _cateItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Menu"]
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(menuAction:)];
    
    self.navigationItem.leftBarButtonItems = @[backItem,_cateItem];
    
    
    
    
    
    UIBarButtonItem *cateItem_0 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"TabIconSettings"]
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(toolBarSettingsAction:)];
    UIBarButtonItem *blankItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                               target:nil
                                                                               action:nil];
    
    
    [self setToolbarItems:@[blankItem,cateItem_0]];
    [self.navigationController setToolbarHidden:NO];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationHandleAction:) name:DSNOTIFICATION_BROWSE_MODE_CHANGE object:nil];
}

- (void)reloadPageViewController
{
    if (_pageViewController)
    {
        DSEpubPageView *pageView = _pageViewController.currentPageView;
        [_pageViewController removeFromParentViewController];
        [_pageViewController.view removeFromSuperview];
        _pageViewController = [[DSPageViewsController alloc] initEpubModel:_epubModel andDSEpubPageView:pageView];
    }
    else
    {
        _pageViewController = [[DSPageViewsController alloc] initEpubModel:_epubModel];
    }
    [self.view addSubview:_pageViewController.view];
    [self addChildViewController:_pageViewController];
    [self.view bringSubviewToFront:_pageViewController.view];
}

- (void)notificationHandleAction:(NSNotification *)sender
{
    if (sender.name == DSNOTIFICATION_BROWSE_MODE_CHANGE)
    {
        [self reloadPageViewController];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setShowCatalog:(BOOL)showCatalog
{
    _showCatalog = showCatalog;
    
    if (showCatalog)
    {
        if (!_catalogViewController) {
            _catalogViewController = [[DSCatalogViewController alloc] initEpubModel:_epubModel];
            
            __weak typeof(self) weakSelf = self;
            [_catalogViewController setSelectedAtChapterIndex:^(NSInteger chaterIndex)
            {
                DSEpubPageView *pageView = weakSelf.pageViewController.currentPageView;
                pageView.chapterIndex = chaterIndex;
                pageView.pageNum = 0;
                pageView.progress = 0;
                [weakSelf reloadPageViewController];
                [[NSNotificationCenter defaultCenter] postNotificationName:DSNOTIFICATION_RELOAD_EPUB object:nil];
                weakSelf.showCatalog = NO;
            }];
            [_catalogViewController.tableView setContentInset:UIEdgeInsetsMake(self.navigationController.navigationBar.height
                                                                               , 0
                                                                               , self.navigationController.toolbar.height
                                                                               , 0)];
            [_catalogViewController.tableView setScrollIndicatorInsets:_catalogViewController.tableView.contentInset];
            [self.view addSubview:_catalogViewController.view];
            [self addChildViewController:_catalogViewController];
        }
        [self.view bringSubviewToFront:_catalogViewController.view];
        _catalogViewController.chapterIndex = _pageViewController.currentPageView.chapterIndex;
        [_cateItem setImage:nil];
        [_cateItem setTitle:@"续读"];
        [self setToolbarItems:nil];
    }
    else
    {
        [self.view bringSubviewToFront:_pageViewController.view];
        [_cateItem setTitle:nil];
        [_cateItem setImage:[UIImage imageNamed:@"Menu"]];
        
        UIBarButtonItem *cateItem_0 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"TabIconSettings"]
                                                                       style:UIBarButtonItemStylePlain
                                                                      target:self
                                                                      action:@selector(toolBarSettingsAction:)];
        UIBarButtonItem *blankItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                   target:nil
                                                                                   action:nil];
        
        [self setToolbarItems:@[blankItem,cateItem_0]];
    }
}

- (void)menuAction:(UIBarButtonItem *)sender
{
    self.showCatalog = !self.showCatalog;
}

- (void)backAction:(id)sender
{
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)toolBarSettingsAction:(UIBarButtonItem *)sender
{
    DSPopoverSettingsViewController *pop = [[DSPopoverSettingsViewController alloc] initWithBarButtonItem:sender];
    [self presentViewController:pop animated:YES completion:nil];
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
