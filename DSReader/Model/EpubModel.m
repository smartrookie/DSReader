//
//  EpubModel.m
//  DSReader
//
//  Created by rookie on 16/7/4.
//  Copyright © 2016年 rookie. All rights reserved.
//

#import "EpubModel.h"

@implementation EpubModel

- (NSString *)path
{
    return [[NSBundle mainBundle] pathForResource:@"yiqiantulong" ofType:@"epub" inDirectory:nil];
}

@end
