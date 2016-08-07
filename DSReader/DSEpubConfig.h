//
//  DSEpubConfig.h
//  DSReader
//
//  Created by rookie on 16/7/6.
//  Copyright © 2016年 rookie. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const DSNOTIFICATION_CHANGE_FONT_SIZE;
extern NSString * const DSNOTIFICATION_BROWSE_MODE_CHANGE;
extern NSString * const DSNOTIFICATION_PAGE_STYLE_CHANGE;

typedef enum : NSUInteger {
    DSPageStyle_Normal,
    DSPageStyle_One,
    DSPageStyle_Two,
    DSPageStyle_Thr,
} DSPageStyle;

typedef enum : NSUInteger {
    DSPageBrowseModel_Page,
    DSPageBrowseModel_Scroll,
} DSPageBrowseModel;


@interface DSEpubConfig : NSObject

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

+ (instancetype)shareInstance;

@property (assign, nonatomic) NSInteger fontSize;
@property (assign, nonatomic) DSPageStyle pageStyle;
@property (assign, nonatomic) DSPageBrowseModel browseModel;

- (NSString *)fontName;

- (UIColor *)paperColorForPageStyle:(DSPageStyle)style;

- (UIColor *)currentThemeColor;


@end
