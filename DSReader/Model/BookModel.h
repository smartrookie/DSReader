//
//  BookModel.h
//  DSReader
//
//  Created by rookie on 16/8/18.
//  Copyright © 2016年 rookie. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    BookType_epub,
    BookType_txt,
    BookType_pdf,
} BookType;

@interface BookModel : NSObject

@property (assign, nonatomic) NSInteger indexId;
@property (strong, nonatomic) NSString *filePath;
@property (assign, nonatomic) BookType  bookType;
@property (assign, nonatomic) BOOL      hasUnzip;

@end
