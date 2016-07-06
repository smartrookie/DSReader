//
//  DSPageViewController.h
//  DSReader
//
//  Created by rookie on 16/6/30.
//  Copyright © 2016年 rookie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EpubModel.h"

@interface DSPageViewsController : UIPageViewController

+ (instancetype)new NS_UNAVAILABLE;

- (instancetype)initEpubModel:(EpubModel *)model;

@end
