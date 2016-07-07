//
//  DSListShelfViewController.m
//  DSReader
//
//  Created by rookie on 16/6/30.
//  Copyright © 2016年 rookie. All rights reserved.
//

#import "DSListShelfController.h"
#import "DSPageViewsController.h"
#import "EpubModel.h"
#import "EpubParser.h"

@interface DSListShelfController ()

@property (nonatomic) NSMutableArray *dataSource;

@end

@implementation DSListShelfController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self.tableView registerClass:[DSListShelfCell class] forCellReuseIdentifier:@"cell"];
    _dataSource = @[].mutableCopy;
    [_dataSource addObject:@"yiqiantulong.epub"];
    [_dataSource addObject:@"yiqiantulong.txt"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    cell.textLabel.text = _dataSource[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    if (indexPath.row == 0) {
        
        EpubModel *epub = [EpubModel new];
        
        EpubParser *parser = [EpubParser new];
        
        if ([parser unzipEpub:epub]) {
            NSLog(@"解压成功");
        } else {
            NSLog(@"解压失败");
        }
        
        
        
        
        
        DSPageViewsController *pageVctrl = [[DSPageViewsController alloc] initEpubModel:epub];
        [self presentViewController:pageVctrl animated:YES completion:nil];
    }
    
    
    
    
}


@end









#pragma mark - DSListShelfCell

@interface DSListShelfCell()

@end

@implementation DSListShelfCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return self;
}

@end




