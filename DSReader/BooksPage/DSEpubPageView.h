//
//  DSEpubPageView.h
//  DSReader
//
//  Created by rookie on 16/7/6.
//  Copyright © 2016年 rookie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EpubModel.h"

@class DSEpubPageView;

typedef enum : NSUInteger {
    Tap_Left,
    Tap_Center,
    Tap_Right,
} Tap_Position;

@protocol DSEpubPageViewTapDelegate <NSObject>

- (void)pageView:(DSEpubPageView *)epubPageView tapPosition:(Tap_Position)position;

@end

@interface DSEpubPageView : UIViewController

@property (weak, nonatomic)id<DSEpubPageViewTapDelegate> tapDelegate;

@property (nonatomic) NSInteger chapterIndex;
@property (nonatomic) NSInteger pageNum;
@property (nonatomic) NSInteger pageCount;


- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new  NS_UNAVAILABLE;

- (instancetype)initWithModel:(EpubModel *)epub;





@end
