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
    //NSLog(@"Href == %@",href);
    
    NSURL* baseURL = [NSURL fileURLWithPath:href];
    [_webView loadHTMLString:[self htmlContentFromFile:href AddJsContent:[self jsContentWithViewRect:self.view.bounds]] baseURL:baseURL];
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

-(NSString*)htmlContentFromFile:(NSString*)fileFullPath AddJsContent:(NSString*)jsContent
{
    NSString *strHTML=nil;
    
    NSError *error=nil;
    NSStringEncoding encoding;
    NSString *strFileContent = [[NSString alloc] initWithContentsOfFile:fileFullPath usedEncoding:&encoding error:&error];
    
    if (strFileContent && [jsContent length]>1)
    {
        NSRange head1=[strFileContent rangeOfString:@"<head>" options:NSCaseInsensitiveSearch];
        NSRange head2=[strFileContent rangeOfString:@"</head>" options:NSCaseInsensitiveSearch];
        
        if (head1.location != NSNotFound && head2.location !=NSNotFound && head2.location>head1.location )
        {
            NSRange rangeHead=head1;
            rangeHead.length=head2.location - head1.location;
            NSString *strHead=[strFileContent substringWithRange:rangeHead];
            
            NSString *str1=[strFileContent substringToIndex:head1.location];
            NSString *str3=[strFileContent substringFromIndex:head2.location];
            
            NSString *strHeadEdit=[NSString stringWithFormat:@"%@\n%@",strHead,jsContent];
            
            strHTML=[NSString stringWithFormat:@"%@%@%@",str1,strHeadEdit,str3];
        }
    }
    else if ( strFileContent )
    {
        strHTML=[NSString stringWithFormat:@"%@",strFileContent];
    }
    
    return strHTML;
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
-(NSString*)jsContentWithViewRect:(CGRect)rectView
{
    //
    //NSString *js0=@"<?xml-stylesheet type=\"text/css\" href=\"font1.css\"?>";
    //    NSString *js0=@"<style type=\"text/css\"> @font-face{ font-family: 'DFPShaoNvW5'; src: url('DFPShaoNvW5-GB.ttf'); } </style> ";
    
    NSString *js0=@"";
    //    if (self.fontSelectIndex == 1) {
    //        NSString *path1=[self fileFindFullPathWithFileName:@"DFPShaoNvW5.ttf" InDirectory:nil];
    //        js0=[self jsFontStyle:path1];
    //    }
    
    NSString *js1=@"<style>img {  max-width:100% ; }</style>\n";
    
    //    NSArray *arrJs2=@[@"<script>"
    //                      ,@"var mySheet = document.styleSheets[0];"
    //                      ,@"function addCSSRule(selector, newRule){"
    //                      ,@"if (mySheet.addRule){"
    //                      ,@"mySheet.addRule(selector, newRule);"
    //                      ,@"} else {"
    //                      ,@"ruleIndex = mySheet.cssRules.length;"
    //                      ,@"mySheet.insertRule(selector + '{' + newRule + ';}', ruleIndex);"
    //                      ,@"}"
    //                      ,@"}"
    //                      ,@"addCSSRule('p', 'text-align: justify;');"
    //                      ,@"addCSSRule('highlight', 'background-color: yellow;');"
    //                      //,@"addCSSRule('body', '-webkit-text-size-adjust: 100%; font-size:10px;');"
    //                      ,@"addCSSRule('body', ' font-size:18px;');"
    //                      ,@"addCSSRule('body', ' margin:2.2em 5%% 0 5%%;');"   //上，右，下，左 顺时针
    //                      ,@"addCSSRule('html', 'padding: 0px; height: 480px; -webkit-column-gap: 0px; -webkit-column-width: 320px;');"
    //                      ,@"</script>"];
    
    NSMutableArray *arrJs=[NSMutableArray array];
    [arrJs addObject:@"<script>"];
    [arrJs addObject:@"var mySheet = document.styleSheets[0];"];
    [arrJs addObject:@"function addCSSRule(selector, newRule){"];
    [arrJs addObject:@"if (mySheet.addRule){"];
    [arrJs addObject:@"mySheet.addRule(selector, newRule);"];
    [arrJs addObject:@"} else {"];
    [arrJs addObject:@"ruleIndex = mySheet.cssRules.length;"];
    [arrJs addObject:@"mySheet.insertRule(selector + '{' + newRule + ';}', ruleIndex);"];
    [arrJs addObject:@"}"];
    [arrJs addObject:@"}"];
    
    
    [arrJs addObject:@"addCSSRule('p', 'text-align: justify;');"];
    [arrJs addObject:@"addCSSRule('highlight', 'background-color: yellow;');"];
    {
        DSEpubConfig *config = [DSEpubConfig shareInstance];
        NSString *css1=[NSString stringWithFormat:@"addCSSRule('body', ' font-size:%@px;');",@(config.fontSize)];
        [arrJs addObject:css1];
    }
    {
        DSEpubConfig *config = [DSEpubConfig shareInstance];
        NSString *css1=[NSString stringWithFormat:@"addCSSRule('body', ' font-family:\"%@\";');",config.fontName];
        [arrJs addObject:css1];
    }
    
    //[arrJs addObject:@"addCSSRule('body', ' margin:2.2em 5%% 0 5%%;');"]; //上，右，下，左 顺时针
    [arrJs addObject:@"addCSSRule('body', ' margin:0 0 0 0;');"];
    {
        //[arrJs addObject:@"addCSSRule('html', 'padding: 0px; height: 480px; -webkit-column-gap: 0px; -webkit-column-width: 320px;');"];
        NSString *css1=[NSString stringWithFormat:@"addCSSRule('html', 'padding: 0px; height: %@px; -webkit-column-gap: 0px; -webkit-column-width: %@px;');",@(rectView.size.height),@(rectView.size.width)];
        [arrJs addObject:css1];
    }
    
    [arrJs addObject:@"</script>"];
    
    NSString *jsJoin=[arrJs componentsJoinedByString:@"\n"];
    
    //NSString *jsRet=[NSString stringWithFormat:@"%@\n%@",js1,jsJoin];
    NSString *jsRet=[NSString stringWithFormat:@"%@\n%@\n%@",js0,js1,jsJoin];
    return jsRet;
}






@end
