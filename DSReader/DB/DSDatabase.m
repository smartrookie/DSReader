//
//  DSDatabase.m
//  DSReader
//
//  Created by zhangdongfeng on 7/25/16.
//  Copyright © 2016 rookie. All rights reserved.
//

#import "DSDatabase.h"
#import "FMDB.h"
#import "AppDelegate.h"
#import "EpubModel.h"

static const char *databaseQueueSpecific = "com.dsreader.databasequeue";
static dispatch_queue_t databaseDispatchQueue = nil;

static DSDatabase *TGDatabaseSingleton = nil;

static const int databaseVersion = 1;

@interface DSDatabase()

- (dispatch_queue_t)databaseQueue;
- (bool)isCurrentQueueDatabaseQueue;
- (void)dispatchOnDatabaseThread:(dispatch_block_t)block synchronous:(bool)synchronous;

@property (nonatomic, strong) NSString *databaseName;
@property (nonatomic, strong) FMDatabase *database;
@property (nonatomic, strong) NSString *databasePath;

@end

DSDatabase *TGDatabaseInstance()
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        TGDatabaseSingleton = [[DSDatabase alloc] init];
    });
    return TGDatabaseSingleton;
}

@implementation DSDatabase

+ (instancetype)instance
{
    return TGDatabaseInstance();
}

- (NSString *)databaseName
{
    return @"dsReaderdata";
}

- (void)initDatabase
{
    _databasePath = [[AppDelegate documentsPath] stringByAppendingPathComponent:self.databaseName];
    _database = [FMDatabase databaseWithPath:_databasePath];
    
    if ([_database open]) {
        NSLog(@"open success");
        
        [_database executeUpdate:@"CREATE TABLE IF NOT EXISTS dbVersion (version INTEGER PRIMARY KEY)"];
    
        FMResultSet *versionResult = [_database executeQuery:@"SELECT version FROM dbVersion"];
        NSInteger dbVerion = 0;
        if ([versionResult next]) {
            dbVerion = [versionResult intForColumnIndex:0];
        }
        NSLog(@"!!!! db Version = %ld",(long)dbVerion);
        
        if (dbVerion == 0) {
            [_database executeUpdate:[NSString stringWithFormat:@"INSERT INTO dbVersion (version) VALUES (?)"],@(databaseVersion)];
        } else {
            [_database executeUpdate:[NSString stringWithFormat:@"UPDATE dbVersion SET version=%d WHERE version=%d",databaseVersion,(int)dbVerion]];
        }
        
        switch (dbVerion) {
            case 0:
                [self createDataBaseVersion0];
            case 1:
                NSLog(@"update to database version 1");
            case 2:
                NSLog(@"update to database version 2");
        }

        
        
    } else {
        NSLog(@"open failure");
    }
    
    return;
}


- (dispatch_queue_t)databaseQueue
{
    if (databaseDispatchQueue == NULL)
    {
        databaseDispatchQueue = dispatch_queue_create(databaseQueueSpecific, 0);
        dispatch_queue_set_specific(databaseDispatchQueue, databaseQueueSpecific, (void *)databaseQueueSpecific, NULL);
    }
    return databaseDispatchQueue;
}

- (bool)isCurrentQueueDatabaseQueue
{
    return dispatch_get_specific(databaseQueueSpecific) != NULL;
}

- (void)dispatchOnDatabaseThread:(dispatch_block_t)block synchronous:(bool)synchronous
{
    if ([self isCurrentQueueDatabaseQueue])
    {
        @autoreleasepool
        {
            block();
        }
    }
    else
    {
        if (synchronous)
        {
            dispatch_sync([self databaseQueue], ^
            {
                @autoreleasepool
                {
                    block();
                }
            });
        }
        else
        {
            dispatch_async([self databaseQueue], ^
            {
               @autoreleasepool
               {
                   block();
               }
            });
        }
    }
}

#pragma mark - database version

- (void)createDataBaseVersion0
{
    NSString *epub_modelSql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS epub_model (eid INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, path TEXT, unzipPath TEXT, manifestPath TEXT, opf_file TEXT, ncx_file TEXT, identifier TEXT, title TEXT, creator TEXT, contributor TEXT, publisher TEXT, date TEXT, subject TEXT, language TEXT, dcdescription TEXT, coverPath TEXT);"];
    
    [_database executeUpdate:epub_modelSql];
    
    NSString *navPoint_modelSql = @"CREATE TABLE IF NOT EXISTS navPoine_model (navId TEXT NOT NULL, eid INTEGER NOT NULL, playOder TEXT, text TEXT, src TEXT, PRIMARY KEY(navId,eid));";
    
    [_database executeUpdate:navPoint_modelSql];
    
    NSString *pageItem_modelSql = @"CREATE TABLE IF NOT EXISTS pageItem_model (itemId TEXT NOT NULL, eid INTEGER NOT NULL, href TEXT, PRIMARY KEY(itemId,eid));";
    
    [_database executeUpdate:pageItem_modelSql];
    
    NSString *pageRef_modelSql = @"CREATE TABLE IF NOT EXISTS pageRef_model (idref TEXT NOT NULL, eid INTEGER NOT NULL, PRIMARY KEY(idref,eid))";
    
    [_database executeUpdate:pageRef_modelSql];
}


- (void)storeEpubModel:(EpubModel *)model
{
    static NSString *sql = @"INSERT OR REPLACE INTO epub_model (eid, path, unzipPath, manifestPath, opf_file, ncx_file, identifier, title, creator, contributor, publisher, date, subject, language, dcdescription, coverPath) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
    [_database executeUpdate:sql,NULL,model.path,model.unzipPath,model.manifestPath,model.opf_file,model.ncx_file,model.identifier,model.title,model.creator,model.contributor,model.publisher,model.date,model.subject,model.language,model.debugDescription,model.coverPath];
    static NSString *sql_s = @"SELECT last_insert_rowid() FROM epub_model;";
    FMResultSet *result = [_database executeQuery:sql_s];
    if (result.next) {
        model.eid = [result intForColumnIndex:0];
    }
    NSLog(@"insert success and new eid = %d",(int)model.eid);
    
}


@end
