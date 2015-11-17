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
    
    self.navigationController.navigationBar.barTintColor = BGCOLOR;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    /*
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
     */
    
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

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}
-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    cell.backgroundColor = [UIColor whiteColor];
    cell.textLabel.textColor = [UIColor blackColor];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
