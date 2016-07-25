//
//  DSCommon.m
//  DSReader
//
//  Created by zhangdongfeng on 7/25/16.
//  Copyright © 2016 rookie. All rights reserved.
//

#import "DSCommon.h"

@implementation DSCommon


int iosMajorVersion()
{
    static bool initialized = false;
    static int version = 7;
    if (!initialized)
    {
        switch ([[[UIDevice currentDevice] systemVersion] intValue])
        {
            case 4:
                version = 4;
                break;
            case 5:
                version = 5;
                break;
            case 6:
                version = 6;
                break;
            case 7:
                version = 7;
                break;
            case 8:
                version = 8;
                break;
            case 9:
                version = 9;
                break;
            default:
                version = 8;
                break;
        }
        
        initialized = true;
    }
    return version;
}

@end
