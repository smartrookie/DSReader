//
//  DSCatalogViewController.h
//  DSReader
//
//  Created by rookie on 16/8/16.
//  Copyright © 2016年 rookie. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EpubModel;

@interface DSCatalogViewController : UITableViewController

+ (instancetype)new NS_UNAVAILABLE;

- (instancetype)initEpubModel:(EpubModel *)epub;

@property (assign, nonatomic) NSInteger chapterIndex;

@property (copy, nonatomic) void (^selectedAtChapterIndex)(NSInteger chaterIndex);

@end
