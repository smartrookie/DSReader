//
//  DSPageViewController.h
//  DSReader
//
//  Created by rookie on 16/6/30.
//  Copyright © 2016年 rookie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EpubModel.h"
@class DSEpubPageView;

@interface DSPageViewsController : UIPageViewController

+ (instancetype)new NS_UNAVAILABLE;

- (instancetype)initEpubModel:(EpubModel *)model;

- (void)setTopBarHidden:(BOOL)hidden;

@property (strong, nonatomic, readonly) DSEpubPageView *currentPageView;
- (instancetype)initEpubModel:(EpubModel *)model andDSEpubPageView:(DSEpubPageView *)pageView;

@end
