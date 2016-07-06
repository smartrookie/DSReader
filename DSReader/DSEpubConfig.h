//
//  DSEpubConfig.h
//  DSReader
//
//  Created by rookie on 16/7/6.
//  Copyright © 2016年 rookie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DSEpubConfig : NSObject

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

+ (instancetype)shareInstance;

- (NSInteger)fontSize;
- (NSString *)fontName;


@end
