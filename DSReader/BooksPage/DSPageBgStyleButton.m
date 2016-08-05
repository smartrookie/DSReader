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
        [self setStyle:DSPageStyle_Normal];
        [self setSelected:NO];
        [self setClipsToBounds:YES];
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self.layer setCornerRadius:frame.size.width/2];
}

- (void)setStyle:(DSPageStyle)style
{
    _style = style;
    switch (style) {
        case DSPageStyle_Normal:
        {
            self.backgroundColor = [UIColor ds_whiteColor];
        }
            break;
        case DSPageStyle_One:
        {
            self.backgroundColor = [UIColor ds_greenColor];
        }
            break;
        case DSPageStyle_Two:
        {
            self.backgroundColor = [UIColor ds_yellowColor];
        }
            break;
        case DSPageStyle_Thr:
        {
            self.backgroundColor = [UIColor ds_darkGrayColor];
        }
            break;
        default:
        {
            self.backgroundColor = [UIColor ds_whiteColor];
        }
            break;
    }
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    if (selected)
    {
        self.layer.borderColor = [UIColor ds_blueColor].CGColor;
    }
    else
    {
        self.layer.borderColor = self.backgroundColor.CGColor;
    }
}

@end
