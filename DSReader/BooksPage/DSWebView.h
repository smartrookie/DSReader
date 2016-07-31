//
//  DSWebView.h
//  DSReader
//
//  Created by rookie on 16/7/6.
//  Copyright © 2016年 rookie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DSWebView : UIWebView

@property (strong, nonatomic) NSString *lastTimeTextSelection; //just a flag

- (NSString *)currentTextSelection;

@end
