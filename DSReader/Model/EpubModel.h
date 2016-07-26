//
//  EpubModel.h
//  DSReader
//
//  Created by rookie on 16/7/4.
//  Copyright © 2016年 rookie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PageRef : NSObject

@property (nonatomic) NSString *idref;

@end

@interface PageItem : NSObject

@property (nonatomic) NSString *itemId;
@property (nonatomic) NSString *href;

@end


@interface NavPoint : NSObject

@property (nonatomic) NSString *navId;
@property (nonatomic) NSString *playOrder;
@property (nonatomic) NSString *text;
@property (nonatomic) NSString *src;

@end



@interface EpubModel : NSObject

@property (nonatomic) NSInteger eid;
@property (nonatomic) NSString *path;
@property (nonatomic) NSString *unzipPath;
@property (nonatomic) NSString *manifestPath;
@property (nonatomic) NSString *opf_file;
@property (nonatomic) NSString *ncx_file;

@property (nonatomic) NSString *identifier;
@property (nonatomic) NSString *title;
@property (nonatomic) NSString *creator;
@property (nonatomic) NSString *contributor;
@property (nonatomic) NSString *publisher;
@property (nonatomic) NSString *date;
@property (nonatomic) NSString *subject;
@property (nonatomic) NSString *language;
@property (nonatomic) NSString *dcdescription;

@property (nonatomic) NSString *coverPath; //封面路径

// 目录章节
@property (nonatomic) NSMutableArray<NavPoint *> *navPoints;
@property (nonatomic) NSMutableArray<PageRef *>  *pageRefs;
@property (nonatomic) NSMutableArray<PageItem *> *pageItems;









@end
