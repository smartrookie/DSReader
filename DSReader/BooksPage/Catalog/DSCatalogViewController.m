//
//  DSCatalogViewController.m
//  DSReader
//
//  Created by rookie on 16/8/16.
//  Copyright © 2016年 rookie. All rights reserved.
//

#import "DSCatalogViewController.h"
#import "EpubModel.h"

@interface DSCatalogViewController ()

@property (strong, nonatomic) EpubModel *epubModel;
@property (strong, nonatomic) NSArray<NavPoint *> *dataSource;

@end

@implementation DSCatalogViewController

- (instancetype)initEpubModel:(EpubModel *)epub
{
    self = [super init];
    _epubModel = epub;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
     self.clearsSelectionOnViewWillAppear = YES;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.tableFooterView = [UIView new];
    
    _dataSource = _epubModel.navPoints;
    self.tableView.estimatedRowHeight = 44;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setChapterIndex:(NSInteger)chapterIndex
{
    PageRef *ref = _epubModel.pageRefs[chapterIndex];
    NSInteger count = -1;
    for (NavPoint *point in _epubModel.navPoints) {
        if ([ref.idref isEqualToString:point.navId]) {
            count = [_epubModel.navPoints indexOfObject:point];
            break;
        }
    }
    
    if (count >= 0)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:count inSection:0];
        [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionMiddle];
    }
    else
    {
        [self.tableView clearSelectedRowsAnimated:NO];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.textLabel.numberOfLines = 0;
    NavPoint *point = _dataSource[indexPath.row];
    cell.textLabel.text = point.text;
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NavPoint *point = _dataSource[indexPath.row];
    NSInteger count = 0;
    for (PageRef *ref in _epubModel.pageRefs) {
        if ([ref.idref isEqualToString:point.navId]) {
            count = [_epubModel.pageRefs indexOfObject:ref];
            break;
        }
    }
    if (_selectedAtChapterIndex) {
        _selectedAtChapterIndex(count);
    }
}


@end
