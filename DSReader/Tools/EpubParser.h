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

+ (NSString *)temUnzipEpubPathAppentPath:(NSString *)subPath;

- (Boolean)unzipEpub:(EpubModel *)epub;


+ (NSString*)jsContentWithViewRect:(CGRect)rectView;
+ (NSString*)htmlContentFromFile:(NSString*)fileFullPath AddJsContent:(NSString*)jsContent;

@end
