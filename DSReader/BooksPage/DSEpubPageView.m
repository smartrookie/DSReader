//
//  DSEpubPageView.m
//  DSReader
//
//  Created by rookie on 16/7/6.
//  Copyright © 2016年 rookie. All rights reserved.
//

#import "DSEpubPageView.h"
#import "DSWebView.h"

@interface DSEpubPageView ()

@property (weak, nonatomic) EpubModel *epub;
@property (nonatomic) DSWebView *webView;

@end

@implementation DSEpubPageView

- (instancetype)initWithModel:(EpubModel *)epub
{
    self = [super init];
    _epub = epub;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _webView = [DSWebView new];
    _webView.frame = self.view.bounds;
    [self.view addSubview:_webView];
    
    NSString *href = [self pageHrefByPageRefIndex:_pageIndex];
    NSLog(@"Href == %@",href);
    
    
    
}


- (NSString *)pageHrefByPageRefIndex:(NSInteger)pageRefIndex
{
    if (pageRefIndex < 0 || pageRefIndex >= _epub.pageRefs.count) return nil;
    
    NSString *idRef = [_epub.pageRefs objectAtIndex:pageRefIndex].idref;
    
    for (PageItem *item in _epub.pageItems) {
        if ([item.itemId isEqualToString:idRef]) {
            return [[[_epub.opf_file stringByDeletingLastPathComponent] stringByAppendingString:@"/"] stringByAppendingString:item.href];
        }
    }

    return nil;
}













- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
