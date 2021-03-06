//
//  EpubParser.m
//  DSReader
//
//  Created by rookie on 16/7/4.
//  Copyright © 2016年 rookie. All rights reserved.
//

#import "EpubParser.h"
#import "ZipArchive.h"
#import "EpubModel.h"
#import "GDataXMLNode.h"
#import "DSEpubConfig.h"
#import "AppDelegate.h"

@interface EpubParser()

@property (nonatomic) EpubModel *epubModel;
@property (nonatomic) NSString  *temUnzipEpubPath;

@end

@implementation EpubParser

+ (NSString *)temUnzipEpubPathAppentPath:(NSString *)subPath
{
    EpubParser *parser = [EpubParser new];
    return [parser temUnzipEpubPathAppentPath:subPath];
}

- (NSString *)temUnzipEpubPathAppentPath:(NSString *)subPath
{
    return [[self temUnzipEpubPath] stringByAppendingPathComponent:subPath];
}

- (NSString *)temUnzipEpubPath
{
    if (_temUnzipEpubPath) return _temUnzipEpubPath;
    else
    {
//        NSString *library   = [NSHomeDirectory() stringByAppendingPathComponent:@"Library"];
//        NSString *caches    = [library stringByAppendingPathComponent:@"Caches"];
//        NSString *epubCache = [caches stringByAppendingPathComponent:@"epubcache"];
//        _temUnzipEpubPath   = [epubCache stringByAppendingString:@"/"];
//        return _temUnzipEpubPath;
        
        NSString *document = [AppDelegate documentsPath];
        NSString *epubCache = [document stringByAppendingPathComponent:@"epubcache"];
        _temUnzipEpubPath   = [epubCache stringByAppendingString:@"/"];
        return _temUnzipEpubPath;
    }
}

- (Boolean)unzipEpub:(EpubModel *)epub
{
    _epubModel = epub;
    if (![self unzipEpubFile])  return NO;
    
    NSLog(@"unzip success");
    
    //--------------------------------------------------------------------------------------------//
    {
        /// opf file
        NSData *manifestData = [NSData dataWithContentsOfFile:[epub absolutePath:epub.manifestPath]];
        if (!manifestData)          return NO;
        
        NSError *error = nil;
        GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:manifestData error:&error];
        if (error)                  return NO;
        
        GDataXMLElement *root = [doc rootElement];
        NSArray *nodes=[root nodesForXPath:@"//@full-path[1]" error:nil];
        if (nodes.count <= 0)       return NO;
        
        GDataXMLElement *opfNode=nodes[0];
        epub.opf_file = [opfNode stringValue];
    }
    
    NSData *opfData = [NSData dataWithContentsOfFile:[epub absolutePath:epub.opf_file]];
    {
        /// opf data
        if (opfData) {
            NSError *error = nil;
            GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:opfData error:&error];
            GDataXMLElement *root = [doc rootElement];
            NSDictionary *mappings=@{@"opf":@"http://www.idpf.org/2007/opf"};
            NSArray* items=[root nodesForXPath:@"//opf:metadata" namespaces:mappings error:&error];
            if (items.count > 0)
            {
                GDataXMLElement *nodeMetadata=items[0];
                for (GDataXMLElement *child in [nodeMetadata children])
                {
                    
                    NSString *key = [child name];
                    NSString *value = [child stringValue];
                    
                    if ([key  isEqualToString: @"dc:identifier"]) {
                        epub.identifier = value;
                    }
                    else if ([key  isEqualToString: @"dc:title"]) {
                        epub.title = value;
                    }
                    else if ([key  isEqualToString: @"dc:creator"]) {
                        epub.creator = value;
                    }
                    else if ([key  isEqualToString: @"dc:contributor"]) {
                        epub.contributor = value;
                    }
                    else if ([key  isEqualToString: @"dc:publisher"]) {
                        epub.publisher = value;
                    }
                    else if ([key  isEqualToString: @"dc:date"]) {
                        epub.date = value;
                    }
                    else if ([key  isEqualToString: @"dc:subject"]) {
                        epub.subject = value;
                    }
                    else if ([key  isEqualToString: @"dc:language"]) {
                        epub.language = value;
                    }
                    else if ([key  isEqualToString: @"dc:description"]) {
                        epub.dcdescription = value;
                    }
                }
            }
        }
    }
    // PageItems
    {
        NSError *error = nil;
        GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:opfData error:&error];
        GDataXMLElement *root = [doc rootElement];
        NSDictionary *mappings=@{@"opf":@"http://www.idpf.org/2007/opf"};
        NSArray* itemsArray =[root nodesForXPath:@"//opf:item" namespaces:mappings error:&error];
        if ([itemsArray count]<1)
        {
            itemsArray =[root nodesForXPath:@"//item" namespaces:mappings error:&error];
        }
        
        for (GDataXMLElement *element in itemsArray)
        {
            NSString *itemId=[[element attributeForName:@"id"] stringValue];
            NSString *itemhref=[[element attributeForName:@"href"] stringValue];
            
            if ([itemId length]>0 && [itemhref length]>0) {
                
                PageItem *item = [PageItem new];
                item.itemId = itemId;
                item.href   = itemhref;
                [epub.pageItems addObject:item];
            }
            
        }
    }
    // Pageref
    {
        NSError *error = nil;
        GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:opfData error:&error];
        GDataXMLElement *root = [doc rootElement];
        
        NSDictionary *mappings=@{@"opf":@"http://www.idpf.org/2007/opf"};
        
        NSArray* itemRefsArray =[root nodesForXPath:@"//opf:itemref" namespaces:mappings error:&error];
        
        if(itemRefsArray.count < 1)
        {
            NSString* xpath = [NSString stringWithFormat:@"//spine[@toc='ncx']/itemref"];
            itemRefsArray = [root nodesForXPath:xpath namespaces:mappings error:&error];
        }
        
        for (GDataXMLElement* element in itemRefsArray)
        {
            NSString *idref=[[element attributeForName:@"idref"] stringValue];
            if (idref && [idref length] > 0) {
                PageRef *pref = [PageRef new];
                pref.idref = idref;
                [epub.pageRefs addObject:pref];
            }
            
        }
    }

    //--------------------------------------------------------------------------------------------//
    
    
    
    
    
    
    {
        //--------------------------------------------------------------------------------------------//
        /// ncx file
        //NSData *opf_Data=[[NSData alloc] initWithContentsOfFile:epub.opf_file];
        if (!opfData)              return NO;
        NSError *error = nil;
        GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:opfData error:&error];
        if (error)                  return NO;
        GDataXMLElement *root = [doc rootElement];
        NSDictionary *mappings=@{@"opf":@"http://www.idpf.org/2007/opf"};
        NSArray *items =[root nodesForXPath:@"//opf:item[@id='ncx']" namespaces:mappings error:&error];
        
        if (items.count < 1) {
            items = [root nodesForXPath:@"//item[@id='ncx']" namespaces:mappings error:&error];
        }
        if (items.count > 0) {
            GDataXMLElement *ncxNode = items[0];
            NSString *ncxhref = [ncxNode attributeForName:@"href"].stringValue;
            if (ncxhref) {
                NSInteger lastSlash = [epub.opf_file rangeOfString:@"/" options:NSBackwardsSearch].location;
                NSString *ebookBasePath = [epub.opf_file substringToIndex:(lastSlash +1)];
                epub.ncx_file = [NSString stringWithFormat:@"%@%@", ebookBasePath, ncxhref];
            } else return NO;
        } else return NO;
        
        
        
        NSData *ncxData = [NSData dataWithContentsOfFile:[epub absolutePath:epub.ncx_file]];
        {
            //目录章节
            NSError *error = nil;
            GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:ncxData error:&error];
            if (!error) {
                GDataXMLElement *root = [doc rootElement];
                NSDictionary *mappings = @{@"ncx":@"http://www.daisy.org/z3986/2005/ncx/"};
                NSArray *navPoints= [root nodesForXPath:@"ncx:navMap/ncx:navPoint" namespaces:mappings error:&error];
                for (GDataXMLElement *navPoint in navPoints) {
                    NSString *navId=[[navPoint attributeForName:@"id"] stringValue];
                    NSString *playOrder=[[navPoint attributeForName:@"playOrder"] stringValue];
                
                    NSArray *textNodes=[navPoint nodesForXPath:@"ncx:navLabel/ncx:text" namespaces:mappings error:nil];
                    NSString *ncx_text=@"";
                    if ([textNodes count]>0) {
                        GDataXMLElement *nodeLabel=textNodes[0];
                        ncx_text=[nodeLabel stringValue];
                    }
                    
                    NSArray *contentNodes=[navPoint nodesForXPath:@"ncx:content" namespaces:mappings error:nil];
                    NSString *ncx_src=@"";
                    if ([contentNodes count]>0) {
                        GDataXMLElement *nodeContent=contentNodes[0];
                        ncx_src=[[nodeContent attributeForName:@"ncx:src"] stringValue];
                    }
                    
                    NavPoint *navPoint = [NavPoint new];
                    navPoint.navId = navId;
                    navPoint.playOrder = playOrder;
                    navPoint.text = ncx_text;
                    navPoint.src = ncx_src;
                    
                    [epub.navPoints addObject:navPoint];
                }
                
            }
        }
        
        
        
        
        
        
        //--------------------------------------------------------------------------------------------//
        
    }
    //拿到首页当然封面
    NSString *idRef = epub.pageRefs.firstObject.idref;
    for (PageItem *item in epub.pageItems) {
        if ([item.itemId isEqualToString:idRef]) {
            epub.coverPath = [[[epub.opf_file stringByDeletingLastPathComponent] stringByAppendingString:@"/"] stringByAppendingString:item.href];
        }
    }
    
    NSLog(@"Epub description = %@",epub.modelDescription);
    return YES;
}

- (Boolean)unzipEpubFile
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:_epubModel.path]) return NO; //No resource;
    
    NSString *fileName = [[_epubModel.path lastPathComponent] stringByDeletingPathExtension];
    NSString *tempUnzipPath = [self.temUnzipEpubPath stringByAppendingString:fileName];
    tempUnzipPath = [tempUnzipPath stringByAppendingString:@"/"];
    _epubModel.unzipPath =  [NSString stringWithFormat:@"%@/",fileName];//  tempUnzipPath;
    
    //NSString *manifestFile = [NSString stringWithFormat:@"%@/META-INF/container.xml", tempUnzipPath];
    _epubModel.manifestPath = @"/META-INF/container.xml";// manifestFile;
     
    ZipArchive *zip = [ZipArchive new];
    
    if (![zip UnzipOpenFile:_epubModel.path]) return NO;
    
    Boolean unzipSuccess = [zip UnzipFileTo:tempUnzipPath overWrite:YES];
    
    [zip UnzipCloseFile];
    
    return unzipSuccess;
}





+ (NSString*)htmlContentFromFile:(NSString*)fileFullPath AddJsContent:(NSString*)jsContent
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


+ (NSString*)jsContentWithViewRect:(CGRect)rectView
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
    
    //        NSArray *arrJs2=@[@"<script>"
    //                          ,@"var mySheet = document.styleSheets[0];"
    //                          ,@"function addCSSRule(selector, newRule){"
    //                          ,@"if (mySheet.addRule){"
    //                          ,@"mySheet.addRule(selector, newRule);"
    //                          ,@"} else {"
    //                          ,@"ruleIndex = mySheet.cssRules.length;"
    //                          ,@"mySheet.insertRule(selector + '{' + newRule + ';}', ruleIndex);"
    //                          ,@"}"
    //                          ,@"}"
    //                          ,@"addCSSRule('p', 'text-align: justify;');"
    //                          ,@"addCSSRule('highlight', 'background-color: yellow;');"
    //                          ,@"addCSSRule('body', '-webkit-text-size-adjust: 100%; font-size:10px;');"
    //                          ,@"addCSSRule('body', ' font-size:18px;');"
    //                          ,@"addCSSRule('body', ' margin:2.2em 5%% 0 5%%;');"   //上，右，下，左 顺时针
    //                          ,@"addCSSRule('html', 'padding: 0px; height: 480px; -webkit-column-gap: 0px; -webkit-column-width: 320px;');"
    //                          ,@"</script>"];
    
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
