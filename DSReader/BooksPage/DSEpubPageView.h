//
//  DSEpubPageView.h
//  DSReader
//
//  Created by rookie on 16/7/6.
//  Copyright © 2016年 rookie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EpubModel.h"

@interface DSEpubPageView : UIViewController


@property (nonatomic) NSInteger pageIndex;


- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new  NS_UNAVAILABLE;

- (instancetype)initWithModel:(EpubModel *)epub;





@end
