//
//  EpubParser.m
//  DSReader
//
//  Created by rookie on 16/7/4.
//  Copyright © 2016年 rookie. All rights reserved.
//

#import "EpubParser.h"
#import "ZipArchive.h"
#import "EpubModel.h"
#import "GDataXMLNode.h"

@interface EpubParser()

@property (nonatomic) EpubModel *epubModel;
@property (nonatomic) NSString  *temUnzipEpubPath;

@end

@implementation EpubParser

- (NSString *)temUnzipEpubPath
{
    if (_temUnzipEpubPath) return _temUnzipEpubPath;
    else
    {
        NSString *library   = [NSHomeDirectory() stringByAppendingPathComponent:@"Library"];
        NSString *caches    = [library stringByAppendingPathComponent:@"Caches"];
        NSString *epubCache = [caches stringByAppendingPathComponent:@"epubcache"];
        _temUnzipEpubPath   = [epubCache stringByAppendingString:@"/"];
        return _temUnzipEpubPath;
    }
}

- (Boolean)unzipEpub:(EpubModel *)epub
{
    _epubModel = epub;
    if (![self unzipEpubFile]) return NO;
    
    NSLog(@"解压成功");
    
    
    
    
    
    
    return [self unzipEpubFile];
}

- (Boolean)unzipEpubFile
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:_epubModel.path]) return NO; //No resource;
    
    NSString *fileName = [[_epubModel.path lastPathComponent] stringByDeletingPathExtension];
    NSString *tempUnzipPath = [self.temUnzipEpubPath stringByAppendingString:fileName];
    tempUnzipPath = [tempUnzipPath stringByAppendingString:@"/"];
    
    NSString *manifestFile = [NSString stringWithFormat:@"%@/META-INF/container.xml", tempUnzipPath];
    _epubModel.manifestPath = manifestFile;
     
    ZipArchive *zip = [ZipArchive new];
    
    if (![zip UnzipOpenFile:_epubModel.path]) return NO;
    
    Boolean unzipSuccess = [zip UnzipFileTo:tempUnzipPath overWrite:YES];
    
    [zip UnzipCloseFile];
    
    return unzipSuccess;
}

@end
