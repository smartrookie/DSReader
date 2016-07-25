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

static const char *databaseQueueSpecific = "com.dsreader.databasequeue";
static dispatch_queue_t databaseDispatchQueue = nil;

static DSDatabase *TGDatabaseSingleton = nil;

static const int databaseVersion = 1;

@interface DSDatabase()

- (dispatch_queue_t)databaseQueue;

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
        
//        [_database close];
        
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




@end
