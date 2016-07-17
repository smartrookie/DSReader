//
//  DSWebView.m
//  DSReader
//
//  Created by rookie on 16/7/6.
//  Copyright © 2016年 rookie. All rights reserved.
//

#import "DSWebView.h"

@implementation DSWebView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (instancetype)init
{
    self = [super init];
    if (self) {
        UIMenuController *menuController = [UIMenuController sharedMenuController];
        UIMenuItem *menuItemNote = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(copyAction:)];
        NSArray *mArray = [NSArray arrayWithObjects:menuItemNote, nil];
        [menuController setMenuItems:mArray];
    }
    return self;
}

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    NSLog(@"%@",NSStringFromSelector(action));
    if (action == @selector(copyAction:)) {
        return YES;
    } else {
        return NO;
    }
}


- (void)copyAction:(id)sender
{
//    NSString* selectionString = [self stringByEvaluatingJavaScriptFromString:@"window.getSelection().toString()"];
    
    
}


- (NSString *)documentTitle
{
   	return [self stringByEvaluatingJavaScriptFromString:@"document.title"];
}



@end
