//
//  DSPagesManagerController.h
//  DSReader
//
//  Created by rookie on 16/8/9.
//  Copyright © 2016年 rookie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EpubModel.h"

@interface DSPagesManagerController : UIViewController

+ (instancetype)new NS_UNAVAILABLE;

- (instancetype)initEpubModel:(EpubModel *)epub;

@end
