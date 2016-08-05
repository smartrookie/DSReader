//
//  DSPageBgStyleButton.m
//  DSReader
//
//  Created by rookie on 16/8/5.
//  Copyright © 2016年 rookie. All rights reserved.
//

#import "DSPageBgStyleButton.h"

@implementation DSPageBgStyleButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.layer setBorderWidth:CGFloatFromPixel(4)];
        [self.layer setCornerRadius:frame.size.width/2];
        [self setStyle:DSPageStyle_Normal];
    }
    return self;
}

- (void)setStyle:(DSPageStyle)style
{
    switch (style) {
        case DSPageStyle_Normal:
        {
            
        }
            break;
        case DSPageStyle_One:
        {
            
        }
            break;
        case DSPageStyle_Two:
        {
            
        }
            break;
        case DSPageStyle_Thr:
        {
            
        }
            break;
        default:
        {
            
        }
            break;
    }
}

@end
