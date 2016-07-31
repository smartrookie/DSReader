//
//  DSGridBookCell.m
//  DSReader
//
//  Created by zhangdongfeng on 7/23/16.
//  Copyright © 2016 rookie. All rights reserved.
//

#import "DSGridBookCell.h"
#import "EpubModel.h"
#import "EpubParser.h"

@interface DSGridBookCell()

@property (strong, nonatomic) UIWebView *coverView;

@end

@implementation DSGridBookCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _coverView = [UIWebView new];
        _coverView.size = CGSizeMake(90, 110);
        _coverView.backgroundColor = [UIColor ds_whiteColor];
        
        _coverView.left = (frame.size.width - _coverView.width ) / 2;
        _coverView.bottom = frame.size.height;
        [self.contentView addSubview:_coverView];
        _coverView.backgroundColor = [UIColor ds_lightGrayColor];
        _coverView.userInteractionEnabled = NO;
    }
    return self;
}

- (void)setBookModel:(EpubModel *)bookModel
{
    _bookModel = bookModel;
    NSURL *url = [NSURL fileURLWithPath:[bookModel absolutePath:bookModel.coverPath]];
    NSString *htmlString = [EpubParser htmlContentFromFile:[bookModel absolutePath:bookModel.coverPath] AddJsContent:[EpubParser jsContentWithViewRect:_coverView.bounds]] ;
    [_coverView loadHTMLString:htmlString baseURL:url];
}

@end
