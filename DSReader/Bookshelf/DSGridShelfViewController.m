//
//  DSGridShelfViewController.m
//  DSReader
//
//  Created by zhangdongfeng on 7/20/16.
//  Copyright © 2016 rookie. All rights reserved.
//

#import "DSGridShelfViewController.h"
#import "DSGridBookCell.h"
#import "EpubParser.h"
#import "EpubModel.h"
#import "DSPageViewsController.h"
#import "DSDatabase.h"
#import "DSNavigationController.h"

@interface DSGridShelfViewController ()<UICollectionViewDelegateFlowLayout>
{
    UICollectionViewLayout *_collectionLayout;
}

@property (nonatomic, strong) NSArray *dataSource;

@end

@implementation DSGridShelfViewController

static NSString * const reuseIdentifier = @"Cell";


- (instancetype)init
{
    _collectionLayout = [[UICollectionViewFlowLayout alloc] init];
    self = [super initWithCollectionViewLayout:_collectionLayout];
    if (self) {
        
    }
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.backgroundColor = [UIColor ds_whiteColor];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerClass:[DSGridBookCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    self.collectionView.alwaysBounceVertical = YES;
    // Do any additional setup after loading the view.
    
    
    _dataSource = [[DSDatabase instance] allEpubModel];
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

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataSource.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DSGridBookCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];

    EpubModel *book = _dataSource[indexPath.row];
    cell.bookModel  = book;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    DSGridBookCell *cell = (DSGridBookCell *)[collectionView cellForItemAtIndexPath:indexPath];
    EpubModel *epub = cell.bookModel;
    DSPageViewsController *pageVctrl = [[DSPageViewsController alloc] initEpubModel:epub];
    
    DSNavigationController *navi = [[DSNavigationController alloc] initWithRootViewController:pageVctrl];
    [self presentViewController:navi animated:YES completion:nil];
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

#pragma mark --UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = ( SCREEN_WIDTH - 10*4 ) / 3 ;
    return CGSizeMake(width, 120);
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}


@end
