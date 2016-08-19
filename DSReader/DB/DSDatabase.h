//
//  DSDatabase.h
//  DSReader
//
//  Created by zhangdongfeng on 7/25/16.
//  Copyright © 2016 rookie. All rights reserved.
//

#import <Foundation/Foundation.h>
@class EpubModel;
@class BookModel;

extern NSString * const DSNOTIFICATION_DATABASE_NEW_BOOK;

@interface DSDatabase : NSObject

+ (instancetype)instance;

- (void)initDatabase;

- (void)storeEpubModel:(EpubModel *)model;



- (NSArray *)allEpubModel;

- (NSArray *)navPointsByEpubId:(NSString *)epuId;
- (NSArray *)pageRefsByEpubId:(NSString *)epuId;;
- (NSArray *)pageItemsByEpubId:(NSString *)epuId;


//BookModel
- (NSArray<BookModel *> *)allBooks;



@end
