//
//  DSEpubPageView.m
//  DSReader
//
//  Created by rookie on 16/7/6.
//  Copyright © 2016年 rookie. All rights reserved.
//

#import "DSEpubPageView.h"
#import "DSWebView.h"
#import "DSEpubConfig.h"
#import "EpubParser.h"

@interface DSEpubPageView ()<UIWebViewDelegate,UIGestureRecognizerDelegate>

@property (weak, nonatomic) EpubModel *epub;
@property (nonatomic) DSWebView *webView;

@property (strong, nonatomic) UILabel *headerLabel;
@property (strong, nonatomic) UILabel *footerLabel;



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
    self.view.backgroundColor = [[DSEpubConfig shareInstance] paperColorForPageStyle:[[DSEpubConfig shareInstance] pageStyle]];
    
    _headerLabel = [UILabel new];
    _headerLabel.left = 20;
    _headerLabel.width = SCREEN_WIDTH;
    _headerLabel.height = 10;
    _headerLabel.bottom = 30;
    //_headerLabel.text = @"第一章";
    _headerLabel.textColor = [UIColor ds_lightGrayColor];
    _headerLabel.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:_headerLabel];
    [self refreshHeaderLabel];
    
    
    _webView = [DSWebView new];
    _webView.frame =  CGRectInset(self.view.bounds,20,40);
    _webView.delegate = self;
    [self.view addSubview:_webView];
    _webView.scrollView.scrollEnabled = NO;
    _webView.scrollView.bounces = NO;
    
    NSString *href = [self pageHrefByPageRefIndex:_chapterIndex];
    NSURL* baseURL = [NSURL fileURLWithPath:href];
    [_webView loadHTMLString:[EpubParser htmlContentFromFile:href AddJsContent:[EpubParser jsContentWithViewRect:self.view.bounds]] baseURL:baseURL];
    _webView.backgroundColor = [UIColor clearColor];
    
    
    _footerLabel = [UILabel new];
    _footerLabel.left = 20;
    _footerLabel.width = _webView.width;
    _footerLabel.height = 10;
    _footerLabel.top = _webView.bottom + 10;
    //_footerLabel.text = @"8 / 208";
    _footerLabel.textColor = [UIColor ds_lightGrayColor];
    _footerLabel.font = [UIFont systemFontOfSize:12];
    _footerLabel.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:_footerLabel];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapAction:)];
    singleTap.numberOfTapsRequired = 1;
    singleTap.numberOfTouchesRequired = 1;
    singleTap.delaysTouchesEnded = NO;
    singleTap.delegate = self;
    
    [_webView addGestureRecognizer:singleTap];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationHandleAction:) name:DSNOTIFICATION_CHANGE_FONT_SIZE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationHandleAction:) name:DSNOTIFICATION_PAGE_STYLE_CHANGE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationHandleAction:) name:DSNOTIFICATION_RELOAD_EPUB object:nil];
    
//    [_webView setHidden:YES];
}
- (void)notificationHandleAction:(NSNotification *)sender
{
    if (sender.name == DSNOTIFICATION_CHANGE_FONT_SIZE)
    {
        NSNumber *fontSize = sender.object;
        NSLog(@"new fontSize = %@",fontSize.stringValue);
        if ([NSThread isMainThread])
        {
            NSString *href = [self pageHrefByPageRefIndex:_chapterIndex];
            NSURL* baseURL = [NSURL fileURLWithPath:href];
            [_webView loadHTMLString:[EpubParser htmlContentFromFile:href AddJsContent:[EpubParser jsContentWithViewRect:self.view.bounds]] baseURL:baseURL];
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^
            {
               NSString *href = [self pageHrefByPageRefIndex:_chapterIndex];
               NSURL* baseURL = [NSURL fileURLWithPath:href];
               [_webView loadHTMLString:[EpubParser htmlContentFromFile:href AddJsContent:[EpubParser jsContentWithViewRect:self.view.bounds]] baseURL:baseURL];
            });
        }
    }
    else if (sender.name == DSNOTIFICATION_PAGE_STYLE_CHANGE)
    {
        DSPageStyle style = [(NSNumber *)sender.object integerValue];
        UIColor *color = [[DSEpubConfig shareInstance] paperColorForPageStyle:style];
        self.view.backgroundColor = color;
        NSString *href = [self pageHrefByPageRefIndex:_chapterIndex];
        NSURL* baseURL = [NSURL fileURLWithPath:href];
        [_webView loadHTMLString:[EpubParser htmlContentFromFile:href AddJsContent:[EpubParser jsContentWithViewRect:self.view.bounds]] baseURL:baseURL];
    }
    else if (sender.name == DSNOTIFICATION_RELOAD_EPUB)
    {
        NSString *href = [self pageHrefByPageRefIndex:_chapterIndex];
        NSURL* baseURL = [NSURL fileURLWithPath:href];
        [_webView loadHTMLString:[EpubParser htmlContentFromFile:href AddJsContent:[EpubParser jsContentWithViewRect:self.view.bounds]] baseURL:baseURL];
        [self refreshHeaderLabel];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - UIGestureRecognizerDelegate

- (void)singleTapAction:(UITapGestureRecognizer *)sender
{
    NSLog(@"sender = %@",NSStringFromCGPoint([sender locationInView:sender.view]));
    NSString *selection = [_webView currentTextSelection];
    
    if (![selection  isEqualToString:@""])
    {
        NSLog(@"selection = %@",selection);
        _webView.lastTimeTextSelection = selection;
    }
    else
    {
        if (_webView.lastTimeTextSelection != nil)
        {
            NSLog(@"~~~~");
        }
        else
        {
            CGPoint tapPoint = [sender locationInView:sender.view];
            if (tapPoint.x <= sender.view.width / 3)
            {
                [self.tapDelegate pageView:self tapPosition:Tap_Left];
            }
            else if (tapPoint.x > sender.view.width / 3 && tapPoint.x < sender.view.width / 3.0 * 2 )
            {
                [self.tapDelegate pageView:self tapPosition:Tap_Center];
            }
            else
            {
                [self.tapDelegate pageView:self tapPosition:Tap_Right];
            }
            NSLog(@"可以进行翻页判断");
        }
        _webView.lastTimeTextSelection = nil;
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return YES;
}


- (NSInteger)pageCount
{
    NSString *jsString = @"document.documentElement.scrollWidth";
    NSInteger chapterWidth = [[_webView stringByEvaluatingJavaScriptFromString:jsString] integerValue];
    NSInteger pageWidth=_webView.bounds.size.width;
    _pageCount = (int)((float)chapterWidth/pageWidth);
    [self refreshFooterLabel];
    return _pageCount;
}

- (void)refreshHeaderLabel
{
    PageRef *ref = _epub.pageRefs[_chapterIndex];
    NSString *text = @"";
    for (NavPoint *nav in _epub.navPoints) {
        if ([nav.navId isEqualToString:ref.idref]) {
            text = nav.text;
            break;
        }
    }
    _headerLabel.text = text;
}

- (void)refreshFooterLabel
{
    NSString *footer = [NSString stringWithFormat:@"%d / %d",(int)_pageNum + 1,(int)_pageCount];
    _footerLabel.text = footer;
}


- (NSString *)pageHrefByPageRefIndex:(NSInteger)pageRefIndex
{
    if (pageRefIndex < 0 || pageRefIndex >= _epub.pageRefs.count) return nil;
    
    NSString *idRef = [_epub.pageRefs objectAtIndex:pageRefIndex].idref;
    
    for (PageItem *item in _epub.pageItems) {
        if ([item.itemId isEqualToString:idRef]) {
            return [_epub absolutePath:[[[_epub.opf_file stringByDeletingLastPathComponent] stringByAppendingString:@"/"] stringByAppendingString:item.href]];
        }
    }

    return nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSString*)jsFontStyle:(NSString*)fontFilePath
{
    //注意 fontName, DFPShaoNvW5.ttf 如果改为 aa.ttf, 那么fontname也应该是“DFPShaoNvW5”，
    //fontName是系统认的名称,非文件名， 我这里把文件名改了，参考本文件的 customFontWithPath 方法得到真正的fontName
    
    NSString *fontFile=[fontFilePath lastPathComponent];
    NSString *fontName=[fontFile stringByDeletingPathExtension];
    //NSString *jsFont=@"<style type=\"text/css\"> @font-face{ font-family: 'DFPShaoNvW5'; src: url('DFPShaoNvW5-GB.ttf'); } </style> ";
    NSString *jsFontStyle=[NSString stringWithFormat:@"<style type=\"text/css\"> @font-face{ font-family: '%@'; src: url('%@'); } </style>",fontName,fontFile];
    
    return jsFontStyle;
}




#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    BOOL should = navigationType != UIWebViewNavigationTypeLinkClicked;
    if (should)
    {
        [self.view setAlpha:0];
    }
    return should;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    DSEpubConfig *config = [DSEpubConfig shareInstance];
    NSString *insertRule = [NSString stringWithFormat:@"addCSSRule('html', 'padding: 0px; height: %fpx; -webkit-column-gap: 0px; -webkit-column-width: %fpx;')", webView.frame.size.height, webView.frame.size.width];
    
    NSString *textSizeRule1 = [NSString stringWithFormat:@"addCSSRule('body', ' font-size:%@px;')", @(config.fontSize)];
    NSString *textSizeRule2 = [NSString stringWithFormat:@"addCSSRule('p', ' font-size:%@px;')", @(config.fontSize)];
    
    [webView stringByEvaluatingJavaScriptFromString:insertRule];
    [webView stringByEvaluatingJavaScriptFromString:textSizeRule1];
    [webView stringByEvaluatingJavaScriptFromString:textSizeRule2];
    
    //背景主题
    //NSString *bodycolor= [NSString stringWithFormat:@"addCSSRule('body', 'background-color: #f6e5c3;')"];
    NSString *themeBodyColor= [[[DSEpubConfig shareInstance] currentThemeColor] hexString];
    NSString *bodycolor= [NSString stringWithFormat:@"addCSSRule('body', 'background-color: %@;')",themeBodyColor];
    [self.webView stringByEvaluatingJavaScriptFromString:bodycolor];
    //
    //    //NSString *textcolor1=[NSString stringWithFormat:@"addCSSRule('h1', 'color: #ffffff;')"];
    //    NSString *themeTextColor=[self.epubVC.arrTheme[self.epubVC.themeIndex] objectForKey:@"textcolor"];
    //    NSString *textcolor1=[NSString stringWithFormat:@"addCSSRule('h1', 'color: %@;')",themeTextColor];
    //    [self.webView stringByEvaluatingJavaScriptFromString:textcolor1];
    //
    //    //NSString *textcolor2=[NSString stringWithFormat:@"addCSSRule('p', 'color: #ffffff;')"];
    //    NSString *textcolor2=[NSString stringWithFormat:@"addCSSRule('p', 'color: %@;')",themeTextColor];
    //    [self.webView stringByEvaluatingJavaScriptFromString:textcolor2];
    
    
    
    
    
    
//    if (self.calcPageOffy && self.pageRefIndex>-1)
//    {
//        //需要计算  页面的信息
//        
//        NSInteger totalWidth = [[webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.scrollWidth"] integerValue];
////
//        NSInteger theWebSizeWidth=webView.bounds.size.width;
    int offCountInPage = (int)self.pageCount;
        //        if (offCountInPage < 0 || offCountInPage >100)
        //        {
        //            NSLog(@"11");
        //        }
//
//        [self.epubVC.dictPageWithOffYCount setObject:[NSString stringWithFormat:@"%@",@(offCountInPage)] forKey:[NSString stringWithFormat:@"%@",@(self.pageRefIndex)]];
//        
//        //
//        self.calcPageOffy=0;    //计算完成
//        
//    }
//    
//    NSInteger currentOffCountInPage=[[self.epubVC.dictPageWithOffYCount objectForKey:[NSString stringWithFormat:@"%@",@(self.pageRefIndex)]] integerValue];
//    
//    //滚动索引
//    if (self.isPrePage) {
//        self.offYIndexInPage=currentOffCountInPage-1;
//    }
//    if (self.offYIndexInPage >= currentOffCountInPage) {
//        self.offYIndexInPage=currentOffCountInPage-1;
//    }
//    if (self.offYIndexInPage <0) {
//        self.offYIndexInPage=0;
//    }
//    
//    
//    //
//    if (self.offYIndexInPage > -1 && self.offYIndexInPage < currentOffCountInPage && currentOffCountInPage>0)
//    {
//        
//        
//        //查找
//        if (self.epubVC.pageIsShowSearchResultText && [self.epubVC.currentSearchText length]>0) {
//            
//            [(EPUBPageWebView*)theWebView highlightAllOccurencesOfString:self.epubVC.currentSearchText];
//        }
//        
//        //笔记
//        for (NSMutableDictionary *item1 in self.epubVC.arrNotes) {
//            NSInteger notePageRefIndex= [[item1 objectForKey:@"PageRefIndex"] integerValue];
//            if (self.pageRefIndex == notePageRefIndex) {
//                
//                NSString *noteContent=[item1 objectForKey:@"NoteContent"];
//                [(EPUBPageWebView*)theWebView highlightAllOccurencesOfString:noteContent];    //ok
//                //                [theWebView underlineAllOccurencesOfString:noteContent];  // 需要 js 调试
//            }
//            
//        }
//        
//        //页码内跳转
    //如果pageNum 值为 -1 ，则为最后一页
    //NSInteger pageNum = _pageNum != -1 ? _pageNum : offCountInPage;
    
    if (_pageNum == -1)
    {
        _pageNum = offCountInPage - 1;
    }
    else if (_progress != 0)
    {
        _pageNum = MAX( (_pageCount * _progress) - 1 , 0 );
    }
    else
    {
        _progress = ((float)_pageNum + 1) / (float)_pageCount;
    }
    [self gotoOffYInPageWithOffYIndex:_pageNum WithOffCountInPage:offCountInPage];
    [self refreshFooterLabel];
}

-(int)gotoOffYInPageWithOffYIndex:(NSInteger)offyIndex WithOffCountInPage:(NSInteger)offCountInPage
{
    //页码内跳转
    if(offyIndex >= offCountInPage)
    {
        offyIndex = offCountInPage - 1;
    }
    
    
    float pageOffset = offyIndex*self.webView.bounds.size.width;
    
    //NSString* goToOffsetFunc = [NSString stringWithFormat:@" function pageScroll(yOffset){ window.scroll(yOffset,0); } "];
    NSString* goToOffsetFunc = [NSString stringWithFormat:@" function pageScroll(xOffset){ window.scroll(xOffset,0); } "];
    NSString* goTo =[NSString stringWithFormat:@"pageScroll(%f)", pageOffset];
    
    [self.webView stringByEvaluatingJavaScriptFromString:goToOffsetFunc];
    [self.webView stringByEvaluatingJavaScriptFromString:goTo];
    
    [self.view setAlpha:1];
    return 1;
}



@end
