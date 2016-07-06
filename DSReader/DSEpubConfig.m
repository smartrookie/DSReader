//
//  DSEpubConfig.m
//  DSReader
//
//  Created by rookie on 16/7/6.
//  Copyright © 2016年 rookie. All rights reserved.
//

#import "DSEpubConfig.h"

@implementation DSEpubConfig

- (instancetype)_init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

+ (instancetype)shareInstance
{
    static DSEpubConfig *config = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        config = [[DSEpubConfig alloc] _init];
    });
    return config;
}

- (NSInteger)fontSize
{
    return 16;
}
- (NSString *)fontName
{
    return @"Helvetica";
}


@end
