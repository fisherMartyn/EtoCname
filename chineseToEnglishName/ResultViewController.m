//
//  ResultViewController.m
//  chineseToEnglishName
//
//  Created by yujixing on 15/11/14.
//  Copyright © 2015年 YM. All rights reserved.
//

#import "ResultViewController.h"
#import "RelateWorkViewController.h"
#import <Masonry.h>

@interface ResultViewController ()

@end

@implementation ResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    //set navi bar
    self.view.backgroundColor  = BGCOLOR;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    UIBarButtonItem * stats = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"stats"] style:UIBarButtonItemStylePlain target:self action:@selector(showStatsAction)];
    self.navigationItem.rightBarButtonItem = stats;
    
    ResultScrollView *scrollView = [[ResultScrollView alloc] initWithFrame:CGRectZero];
    scrollView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:scrollView];
    
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.view.mas_top).with.offset(150);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-50);
    }];
    
    

}
-(void) showStatsAction
{
    RelateWorkViewController *view = [[RelateWorkViewController alloc] init];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:view];
    [self presentViewController:navi animated:YES completion:nil];
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

@implementation ResultScrollView
-(instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.showsHorizontalScrollIndicator = YES;
        self.showsVerticalScrollIndicator = NO;
        self.pagingEnabled = YES;
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.contentSize = CGSizeMake(self.frame.size.width*10, self.frame.size.height);
}

@end