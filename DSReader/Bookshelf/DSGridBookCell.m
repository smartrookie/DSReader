//
//  DSGridBookCell.m
//  DSReader
//
//  Created by zhangdongfeng on 7/23/16.
//  Copyright © 2016 rookie. All rights reserved.
//

#import "DSGridBookCell.h"

@interface DSGridBookCell()

@property (strong, nonatomic) UIImageView *coverView;

@end

@implementation DSGridBookCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _coverView = [UIImageView new];
        _coverView.size = CGSizeMake(90, 110);
        _coverView.backgroundColor = [UIColor ds_whiteColor];
        
        _coverView.left = (frame.size.width - _coverView.width ) / 2;
        _coverView.bottom = frame.size.height;
        [self.contentView addSubview:_coverView];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

@end
