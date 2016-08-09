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

@interface DSPagesManagerController ()

@property (strong, nonatomic) EpubModel *epubModel;
@property (strong, nonatomic) DSPageViewsController *pageViewController;

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
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"NavigationBackArrowNormal"]
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(backAction:)];
    
    UIBarButtonItem *cateItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Menu"]
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(backAction:)];
    
    self.navigationItem.leftBarButtonItems = @[backItem,cateItem];
    
    
    
    
    
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

- (void)notificationHandleAction:(NSNotification *)sender
{
    if (sender.name == DSNOTIFICATION_BROWSE_MODE_CHANGE)
    {
        DSEpubPageView *pageView = _pageViewController.currentPageView;
        [_pageViewController removeFromParentViewController];
        [_pageViewController.view removeFromSuperview];
        _pageViewController = [[DSPageViewsController alloc] initEpubModel:_epubModel andDSEpubPageView:pageView];
        [self.view addSubview:_pageViewController.view];
        [self addChildViewController:_pageViewController];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
