//
//  DSPopoverSettingsViewController.m
//  DSReader
//
//  Created by rookie on 16/8/4.
//  Copyright © 2016年 rookie. All rights reserved.
//
#import "DSPopoverSettingsViewController.h"
#import "DSEpubConfig.h"
#import "DSPageBgStyleButton.h"


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


@interface __BackgroundStyleCell : UITableViewCell

@property (strong, nonatomic) NSMutableArray *buttons;

@end

@implementation __BackgroundStyleCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    
    _buttons = @[].mutableCopy;
    int styles[] = {DSPageStyle_Normal,DSPageStyle_One,DSPageStyle_Two,DSPageStyle_Thr};
    for (int i = 0; i < 4; i++) {
        DSPageBgStyleButton *btn = [DSPageBgStyleButton new];
        btn.style = styles[i];
        btn.frame = CGRectMake(30 + (i*62.5), 5, 50, 50);
        [self.contentView addSubview:btn];
        [btn addTarget:self action:@selector(pageStyleButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_buttons addObject:btn];
    }
    
    [self pageStyleButtonAction:nil];
    
    return self;
}

- (void)pageStyleButtonAction:(DSPageBgStyleButton *)sender
{
    DSPageStyle style;
    
    if (sender)
    {
        style = sender.style;
        [[DSEpubConfig shareInstance] setPageStyle:style];
    }
    else
    {
        style = [[DSEpubConfig shareInstance] pageStyle];
    }
    
    for (DSPageBgStyleButton *btn in _buttons)
    {
        if (btn.style == style)
        {
            btn.selected = YES;
        }
        else
        {
            btn.selected = NO;
        }
    }
}


@end



@interface __BrowseModelCell : UITableViewCell

@property (strong, nonatomic) UISwitch *choiceModelSwitch;

@end

@implementation __BrowseModelCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    self.textLabel.text = @"翻页浏览";
    
    _choiceModelSwitch = [UISwitch new];
    _choiceModelSwitch.on = [[DSEpubConfig shareInstance] browseModel] == DSPageBrowseModel_Page;
    self.accessoryView = _choiceModelSwitch;
    [_choiceModelSwitch addTarget:self action:@selector(browseModelChange:) forControlEvents:UIControlEventValueChanged];
    
    return self;
}

- (void)browseModelChange:(UISwitch *)sender
{
    if (sender.isOn)
    {
        [[DSEpubConfig shareInstance] setBrowseModel:DSPageBrowseModel_Page];
    }
    else
    {
        [[DSEpubConfig shareInstance] setBrowseModel:DSPageBrowseModel_Scroll];
    }
}


@end































@interface DSPopoverSettingsViewController ()<UIPopoverPresentationControllerDelegate>

@property (strong, nonatomic) __LightControlCell  *lightControlCell;
@property (strong, nonatomic) __FontAjustSizeCell *fontAjustSizeCell;
@property (strong, nonatomic) __BackgroundStyleCell *backgroundStyleCell;
@property (strong, nonatomic) __BrowseModelCell   *browseModelCell;

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
    
    _backgroundStyleCell = [__BackgroundStyleCell new];
    _browseModelCell = [__BrowseModelCell new];
}

- (void)adjustFontAction:(UIButton *)sender
{
    if (sender == _fontAjustSizeCell.minuButton)
    {
        NSLog(@"变小");
        [DSEpubConfig shareInstance].fontSize--;
    }
    else if (sender == _fontAjustSizeCell.plusButton)
    {
        NSLog(@"变大");
        [DSEpubConfig shareInstance].fontSize++;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    NSInteger number = 0;
    
    switch (section)
    {
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row     = indexPath.row;
    if (section == 1 && row == 1)
    {
        return 60;
    }
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
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
    else if (section == 1 && row == 1)
    {
        return _backgroundStyleCell;
    }
    else if (section == 2 && row == 0)
    {
        return _browseModelCell;
    }
    
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    // Configure the cell...
    
    return cell;
}


#pragma mark - UIPopoverPresentationControllerDelegate
- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller{
    return UIModalPresentationNone;
}

@end
