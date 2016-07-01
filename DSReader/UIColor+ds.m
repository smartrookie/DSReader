//
//  UIColor+dsr.m
//  DSReader
//
//  Created by rookie on 16/7/1.
//  Copyright © 2016年 rookie. All rights reserved.
//

#import "UIColor+ds.h"
#import "YYKit.h"

@implementation UIColor (ds)


+ (UIColor *)ds_darkGrayColor
{
    return [UIColor colorWithHexString:@"#444a5a"];
}

+ (UIColor *)ds_lightGrayColor
{
    return [UIColor colorWithHexString:@"#acb3bb"];
}

+ (UIColor *)ds_micrGrayoolor
{
    return [UIColor colorWithHexString:@"#dbdbdd"];
}

+ (UIColor *)ds_blueColor
{
    return [UIColor colorWithHexString:@"#1777cb"];
}

+ (UIColor *)ds_yellowColor
{
    return [UIColor colorWithHexString:@"#ddba76"];
}

+ (UIColor *)ds_greenColor
{
    return [UIColor colorWithHexString:@"#20ab36"];
}

+ (UIColor *)ds_whiteColor
{
    return [UIColor colorWithHexString:@"#f9f9f9"];
}

+ (UIColor *)ds_lightWhiteColor
{
    return [UIColor colorWithHexString:@"#f2f2f2"];
}

@end
