//
//  DSPageBgStyleButton.h
//  DSReader
//
//  Created by rookie on 16/8/5.
//  Copyright © 2016年 rookie. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    DSPageStyle_Normal,
    DSPageStyle_One,
    DSPageStyle_Two,
    DSPageStyle_Thr,
} DSPageStyle;

@interface DSPageBgStyleButton : UIControl

@property (assign, nonatomic) DSPageStyle style;

@end
