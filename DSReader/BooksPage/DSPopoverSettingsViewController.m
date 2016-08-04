//
//  DSPopoverSettingsViewController.m
//  DSReader
//
//  Created by rookie on 16/8/4.
//  Copyright © 2016年 rookie. All rights reserved.
//
#import "DSPopoverSettingsViewController.h"


// UIScreen Brightness
@interface __LightControlCell : UITableViewCell
{
    UIImageView *_leftIcon;
    UIImageView *_rightIcon;
}

@property (strong, nonatomic) UISlider *sliderView;

@end

@implementation __LightControlCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    _sliderView = [[UISlider alloc] init];
    
    _leftIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sun_filled"]];
    _leftIcon.size = CGSizeMake(16, 16);
    _leftIcon.left = 10;
    _leftIcon.centerY = 22;
    [self.contentView addSubview:_leftIcon];
    
    
    _rightIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sun"]];
    _rightIcon.size = CGSizeMake(16, 16);
    _rightIcon.right = 300 - 10;
    _rightIcon.centerY = 22;
    [self.contentView addSubview:_rightIcon];
    
    [_sliderView setSize:CGSizeMake(_rightIcon.left - _leftIcon.right - 8, 30)];
    _sliderView.left = _leftIcon.right + 4;
    _sliderView.centerY = 22;
    [self.contentView addSubview:_sliderView];
    
    [_sliderView setMaximumValue:1];
    [_sliderView setMinimumValue:0];
    
    _sliderView.value = [[UIScreen mainScreen] brightness];
    
    [_sliderView addBlockForControlEvents:UIControlEventValueChanged block:^(UISlider *sender) {
        [[UIScreen mainScreen] setBrightness:sender.value];
    }];
    
    return self;
}

@end


// Font Size

@interface __FontAjustSizeCell : UITableViewCell
{
    CALayer *_middleLine;
}
@property (strong, nonatomic) UIButton *minuButton;
@property (strong, nonatomic) UIButton *plusButton;


@end

@implementation __FontAjustSizeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    _minuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_minuButton setFrame:CGRectMake(0, 0, 300/2 -0.5, 44)];
    [_minuButton setTitle:@"小A" forState:UIControlStateNormal];
    [self.contentView addSubview:_minuButton];
    [_minuButton setTitleColor:[UIColor ds_blueColor] forState:UIControlStateNormal];

    _plusButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_plusButton setFrame:CGRectMake(0, 0, 300/2 -0.5, 44)];
    [_plusButton setTitle:@"大A" forState:UIControlStateNormal];
    _plusButton.left = _minuButton.width + 1;
    [self.contentView addSubview:_plusButton];
    [_plusButton setTitleColor:[UIColor ds_blueColor] forState:UIControlStateNormal];
    
    _middleLine = [CALayer new];
    _middleLine.width = CGFloatFromPixel(1);
    _middleLine.height = 44;
    _middleLine.backgroundColor = [UIColor ds_micrGrayoolor].CGColor;
    _middleLine.left = _minuButton.width;
    [self.contentView.layer addSublayer:_middleLine];
    
    return self;
}

@end






































@interface DSPopoverSettingsViewController ()<UIPopoverPresentationControllerDelegate>

@property (strong, nonatomic) __LightControlCell  *lightControlCell;
@property (strong, nonatomic) __FontAjustSizeCell *fontAjustSizeCell;

@end

@implementation DSPopoverSettingsViewController

- (instancetype)initWithBarButtonItem:(UIBarButtonItem *)buttonItem
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationPopover;
        self.preferredContentSize = CGSizeMake(300 , 200);
//        self.popoverPresentationController.sourceView = sourceView;  //rect参数是以view的左上角为坐标原点（0，0）
//        self.popoverPresentationController.sourceRect = sourceView.bounds; //指定箭头所指区域的矩形框范围（位置和尺寸），以view的左上角为坐标原点
        self.popoverPresentationController.backgroundColor = [UIColor ds_whiteColor];
        self.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionDown; //箭头方向
        self.popoverPresentationController.delegate = self;
        self.popoverPresentationController.barButtonItem = buttonItem;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
     self.clearsSelectionOnViewWillAppear = YES;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.tableView setScrollEnabled:NO];
    
    _lightControlCell = [__LightControlCell new];
    _fontAjustSizeCell = [__FontAjustSizeCell new];
    [_fontAjustSizeCell.minuButton addTarget:self
                                      action:@selector(adjustFontAction:)
                            forControlEvents:UIControlEventTouchUpInside];
    [_fontAjustSizeCell.plusButton addTarget:self
                                      action:@selector(adjustFontAction:)
                            forControlEvents:UIControlEventTouchUpInside];
}

- (void)adjustFontAction:(UIButton *)sender
{
    if (sender == _fontAjustSizeCell.minuButton)
    {
        NSLog(@"变小");
    }
    else if (sender == _fontAjustSizeCell.plusButton)
    {
        NSLog(@"变大");
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger number = 0;
    
    switch (section) {
        case 0:
            number = 1;
            break;
        case 1:
            number = 2;
            break;
        case 2:
            number = 1;
            break;
        default:
            number = 0;
            break;
    }
    return number;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    if (section == 0)
    {
        return _lightControlCell;
    }
    else if (section == 1 && row == 0)
    {
        return _fontAjustSizeCell;
    }
    
    
    
    
    
    
    
    
    
    
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    // Configure the cell...
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark - UIPopoverPresentationControllerDelegate
- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller{
    return UIModalPresentationNone;
}

@end
