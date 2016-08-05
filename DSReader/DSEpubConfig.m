//
//  DSEpubConfig.m
//  DSReader
//
//  Created by rookie on 16/7/6.
//  Copyright © 2016年 rookie. All rights reserved.
//

#import "DSEpubConfig.h"

NSString * const DSNOTIFICATION_CHANGE_FONT_SIZE = @"DSNOTIFICATION_CHANGE_FONT_SIZE";

@implementation DSEpubConfig

- (instancetype)_init
{
    self = [super init];
    if (self) {
        _fontSize = 16;
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

- (void)setFontSize:(NSInteger)fontSize
{
    if (fontSize > 10 && fontSize < 30)
    {
        _fontSize = fontSize;
        [[NSNotificationCenter defaultCenter] postNotificationName:DSNOTIFICATION_CHANGE_FONT_SIZE object:@(fontSize)];
    }
}

- (NSString *)fontName
{
    return @"Helvetica";
}


@end
