//
//  EpubModel.m
//  DSReader
//
//  Created by rookie on 16/7/4.
//  Copyright © 2016年 rookie. All rights reserved.
//

#import "EpubModel.h"

@implementation EpubModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        _navPoints = @[].mutableCopy;
        _pageRefs = @[].mutableCopy;
        _pageItems = @[].mutableCopy;
    }
    return self;
}

- (NSString *)path
{
    return [[NSBundle mainBundle] pathForResource:@"yiqiantulong" ofType:@"epub" inDirectory:nil];
}

@end


@implementation NavPoint
@end

@implementation PageItem
@end

@implementation PageRef
@end