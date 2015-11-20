//
//  RelateWorkViewController.m
//  chineseToEnglishName
//
//  Created by yujixing on 15/11/14.
//  Copyright © 2015年 YM. All rights reserved.
//


#import "RelateWorkViewController.h"

@interface RelateWorkViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic,strong) UITableView *tableview;
@property (nonatomic,strong) NSMutableArray *words;
@property (nonatomic,strong) NSMutableArray *links;
@end

@implementation RelateWorkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor  = RGBCOLOR(0xf8, 0xf8, 0xf8);
    
    /*
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.navigationItem.title = @"我们的app";
     */
    self.navigationController.navigationBar.barTintColor = BGCOLOR;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(popback)];
    self.navigationItem.rightBarButtonItem = right;
    
    
    [self.view addSubview:self.tableview];
    self.tableview.dataSource  = self;
    self.tableview.delegate = self;
    WS(ws);
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(ws.view.mas_width);
        make.height.equalTo(ws.view.mas_height);
        make.top.equalTo(ws.view.mas_top).with.offset(40);
        make.centerX.equalTo(ws.view.mas_centerX);
    }];
}

-(UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
    view.backgroundColor = [UIColor clearColor];
    UILabel *label;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, self.view.frame.size.width-20, 20)];
    } else {
        label = [[UILabel alloc] initWithFrame:CGRectMake(45, 0, self.view.frame.size.width-20, 20)];
    }
    label.backgroundColor = [UIColor clearColor];
    label.text = @"我们的app";
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = RGBCOLOR(0x87, 0x87, 0x87);
    [view addSubview:label];
    return view;
}
-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 28;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *iTunesLink;
    switch (indexPath.row) {
        case 0:
            iTunesLink = @"https://itunes.apple.com/app/apple-store/id980801998?pt=56993800&ct=english_name&mt=8";
            break;
        case 1:
            iTunesLink = @"https://itunes.apple.com/app/apple-store/id989527141?pt=56993800&ct=english_name&mt=8";
            break;
        case 2:
            iTunesLink = @"https://itunes.apple.com/app/apple-store/id850498024?pt=56993800&ct=english_name&mt=8";
            break;
        case 3:
            iTunesLink = @"https://itunes.apple.com/app/apple-store/id862907539?pt=56993800&ct=english_name&mt=8";
            break;
        default:
            break;
    }
    if (iTunesLink) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink]];
    }
}
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}
-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    cell.backgroundColor = [UIColor whiteColor];
    //cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.textColor = RGBCOLOR(0x00, 0x7a, 0xff);
    cell.textLabel.text = [self.words objectAtIndex:indexPath.row];
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    return cell;
}


-(NSMutableArray *)words
{
    if (!_words) {
        _words = [NSMutableArray arrayWithObjects:@"截屏拼接",@"文字转图片", @"莫奈作品308幅", @"梵高作品314幅", nil];
    }
    return _words;
}
-(NSMutableArray *) links
{
    if (!_links) {
        _links = [NSMutableArray arrayWithObjects:@"1",@"2",@"3",@"4",nil];
    }
    return _links;
}

-(void) popback
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

-(UITableView *)tableview
{
    if (!_tableview) {
        _tableview = [[UITableView alloc] initWithFrame:CGRectZero];
        _tableview.tableHeaderView = nil;
        //set footer size to nil to clear extra lines
        _tableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _tableview.scrollEnabled = NO;
        _tableview.backgroundColor = [UIColor clearColor];
    }
    return _tableview;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
