//
//  DSPageView.m
//  DSReader
//
//  Created by rookie on 16/7/1.
//  Copyright © 2016年 rookie. All rights reserved.
//

#import "DSPageView.h"
#import "UIColor+ds.h"
#import "YYKit.h"

@interface DSPageView()

@property (nonatomic) YYTextView *textView;

@end

@implementation DSPageView

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor ds_lightGrayColor];
    
    _textView = [YYTextView new];
    _textView.frame = self.view.bounds;
    
    _textView.text = @"Hello world!!!";
    
    _textView.editable = NO;
    [self.view addSubview:_textView];
    
    
    
    
    
}

@end
