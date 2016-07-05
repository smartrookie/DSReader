//
//  EpubParser.h
//  DSReader
//
//  Created by rookie on 16/7/4.
//  Copyright © 2016年 rookie. All rights reserved.
//

#import <Foundation/Foundation.h>

@class EpubModel;

@interface EpubParser : NSObject

- (Boolean)unzipEpub:(EpubModel *)epub;


@end
