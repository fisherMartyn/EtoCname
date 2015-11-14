//
//  ViewController.m
//  chineseToEnglishName
//
//  Created by yujixing on 15/11/14.
//  Copyright © 2015年 YM. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "Xing.h"
#import "ResultViewController.h"
#import <Masonry.h>

@interface ViewController ()

@property (nonatomic,strong) UITextField * textView;
@property (nonatomic,strong) GenderBtn *leftBtn;
@property (nonatomic,strong) GenderBtn *middleBtn;
@property (nonatomic,strong) GenderBtn *rightBtn;

@property (nonatomic,strong) OtherBtn *sound2;
@property (nonatomic,strong) OtherBtn *sound3;
@property (nonatomic,strong) OtherBtn *shortBtn;
@property (nonatomic,strong) OtherBtn *longBtn;
@property (nonatomic,strong) OtherBtn *confirm;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    
    self.view.backgroundColor = BGCOLOR;
    
    [self.view addSubview:self.textView];
    [self.view addSubview:self.leftBtn];
    [self.view addSubview:self.rightBtn];
    [self.view addSubview:self.middleBtn];
    [self.view addSubview:self.confirm];
    [self.view addSubview:self.sound2];
    [self.view addSubview:self.sound3];
    [self.view addSubview:self.shortBtn];
    [self.view addSubview:self.longBtn];
    
    /* 第一次加载时读入数据 */
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:@"clear" forKey:@"firstLoad"]; //use to clear data.
    NSString *firstload  = [[NSUserDefaults standardUserDefaults] objectForKey:@"firstLoad"];
    if (![firstload isEqualToString:@"loaded"]) {
        
        NSLog(@"firstload");
        //load data to coredata here.
        [userDefaults setObject:@"loaded" forKey:@"firstLoad"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self loadData];
    }
    
    WS(ws);
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ws.view.mas_centerX);
        make.left.equalTo(ws.view.mas_left).with.offset(30);
        make.right.equalTo(ws.view.mas_right).with.offset(-30);
        make.top.equalTo(ws.view.mas_top).with.offset(100);
        make.height.mas_equalTo(40);
    }];
    [self.middleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ws.view.mas_centerX);
        make.top.equalTo(ws.textView.mas_bottom).with.offset(40);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
    [self.leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.middleBtn.mas_top);
        make.size.mas_equalTo(CGSizeMake(60, 60));
        make.right.mas_equalTo(ws.middleBtn.mas_left).with.offset(-40);
    }];
    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.middleBtn.mas_top);
        make.size.mas_equalTo(CGSizeMake(60, 60));
        make.left.mas_equalTo(ws.middleBtn.mas_right).with.offset(40);
    }];
    [self.sound2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.middleBtn.mas_bottom).with.offset(40);
        make.left.equalTo(ws.view.mas_left).with.offset(40);
        make.right.equalTo(ws.middleBtn.mas_centerX).with.offset(-20);
        make.height.mas_equalTo(40);
    }];
    [self.sound3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.middleBtn.mas_bottom).with.offset(40);
        make.right.equalTo(ws.view.mas_right).with.offset(-40);
        make.left.equalTo(ws.middleBtn.mas_centerX).with.offset(20);
        make.height.mas_equalTo(40);
        
    }];
    
    [self.shortBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.sound2.mas_bottom).with.offset(40);
        make.left.equalTo(ws.view.mas_left).with.offset(40);
        make.right.equalTo(ws.middleBtn.mas_centerX).with.offset(-20);
        make.height.mas_equalTo(40);
    }];
    [self.longBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.sound2.mas_bottom).with.offset(40);
        make.right.equalTo(ws.view.mas_right).with.offset(-40);
        make.left.equalTo(ws.middleBtn.mas_centerX).with.offset(20);
        make.height.mas_equalTo(40);
    }];
    
    [self.confirm mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(ws.view.mas_bottom).with.offset(-50);
        make.left.equalTo(ws.view.mas_left).with.offset(50);
        make.right.equalTo(ws.view.mas_right).with.offset(-50);
        make.height.mas_equalTo(40);
    }];
    
    
    }
-(void) loadData
{
    //从文件里读姓
    NSString*filePath=[[NSBundle mainBundle] pathForResource:@"Xing"ofType:@"txt"];
    NSError *err;
    NSString *str = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&err];
    
    NSArray *rows = [str componentsSeparatedByString:@"\n"];
    /*
    for (NSString *row in rows)
    {
        NSArray *fields = [row componentsSeparatedByString:@"--"];
        NSString *chinese = [fields firstObject];
        NSLog(@"%@",chinese);
        NSArray *english = [[fields lastObject] componentsSeparatedByString:@"/"];
        for (NSString * word in english) {
            NSLog(@"%@",word);
        }
    }
     */
    //从文件里读相似文件
    
    /*
    filePath = [[NSBundle mainBundle] pathForResource:@"Similar" ofType:@"txt"];
    str = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&err];
    rows = [str componentsSeparatedByString:@"\n"];
    
    int groupid = 1;
    for (NSString *row  in rows) {
        
        NSArray *fields = [row componentsSeparatedByString:@";"];
        for (NSString* aname in fields) {
            if ([aname isEqualToString:@""]) {
                continue;
            }
            NSLog(@"%@ %d",aname,groupid);
        }
        ++groupid;
    }
     */
    
    //从文件里读取
    filePath = [[NSBundle mainBundle] pathForResource:@"Info" ofType:@"txt"];
    str = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&err];
    
    rows = [str componentsSeparatedByString:@"\n"];
    
    for (NSString * row in rows) {
        NSArray *fields = [row componentsSeparatedByString:@";"];
        if (fields.count <8 ) {
            continue;
        }
        NSString *englishName  = [fields objectAtIndex:0];
        NSString *englishNameCnt =[fields objectAtIndex:1];
        NSString *chineseName = [fields objectAtIndex:2];
        NSString *chineseNameCnt = [fields objectAtIndex:3];
        NSString *sexInfo = [fields objectAtIndex:4];
        NSString *englishFayin = [fields objectAtIndex:5];
        NSString *popularCnt = [fields objectAtIndex:6];
        NSString *pinyinFayin = [fields objectAtIndex:7];
        NSLog(@"%@",fields);
    }
    
    
#if 0
    //test coredata
    //save data
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    Xing *entry = [NSEntityDescription insertNewObjectForEntityForName:@"Xing" inManagedObjectContext:appdelegate.managedObjectContext];
    [entry setEnglish:@"eng"];
    [entry setChinese:@"中文"];
    NSError *error;
    
    //托管对象准备好后，调用托管对象上下文的save方法将数据写入数据库
    BOOL isSaveSuccess = [appdelegate.managedObjectContext save:&error];
    
    if (!isSaveSuccess) {
        NSLog(@"Error: %@,%@",error,[error userInfo]);
    }else {
        NSLog(@"Save successful!");
    }
#endif
}
-(void) fetchData
{
    //load data
    
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Xing"];
    NSError *error;
    NSPredicate *predict = [NSPredicate predicateWithFormat:@"english=\"eng\""];
    request.predicate = predict;
    NSMutableArray *mutableFetchResult = [[appdelegate.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    for (Xing *entry in mutableFetchResult) {
        NSLog(@"%@ --- %@" ,entry.chinese,entry.english);
    }

    
}

-(UITextField*) textView
{
    if (!_textView) {
        _textView = [[UITextField  alloc] initWithFrame:CGRectZero];
        _textView.layer.cornerRadius = 10;
        _textView.backgroundColor = [UIColor whiteColor];
        _textView.placeholder = @"中文名";
        [_textView setFont:[UIFont boldSystemFontOfSize:25]];
        _textView.textAlignment = NSTextAlignmentCenter;
        _textView.layer.masksToBounds = YES;
        
    }
    return _textView;
}

-(void) GenderSelect:(GenderBtn *)sender
{
    [self.leftBtn setSelected:NO];
    [self.middleBtn setSelected:NO];
    [self.rightBtn setSelected:NO];
    [sender setSelected:YES];
}
-(GenderBtn*) leftBtn
{
    if (!_leftBtn) {
        _leftBtn = [[GenderBtn alloc] initWithFrame:CGRectZero];
        [_leftBtn setTitle:@"女" forState:UIControlStateNormal];
        [_leftBtn setTitle:@"女" forState:UIControlStateSelected];
        [_leftBtn addTarget:self action:@selector(GenderSelect:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftBtn;
}
-(GenderBtn *)middleBtn
{
    if (!_middleBtn) {
        _middleBtn = [[GenderBtn alloc] initWithFrame:CGRectZero];
        [_middleBtn setTitle:@"中性" forState:UIControlStateNormal];
        [_middleBtn setTitle:@"中性" forState:UIControlStateSelected];
        [_middleBtn addTarget:self action:@selector(GenderSelect:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _middleBtn;
}
-(GenderBtn*) rightBtn
{
    if (!_rightBtn) {
        _rightBtn = [[GenderBtn alloc] initWithFrame:CGRectZero];
        [_rightBtn setTitle:@"男" forState:UIControlStateNormal];
        [_rightBtn setTitle:@"男" forState:UIControlStateSelected];
        [_rightBtn addTarget:self action:@selector(GenderSelect:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBtn;
}

-(OtherBtn *) sound2
{
    if (!_sound2) {
        _sound2 = [[OtherBtn alloc] initWithFrame:CGRectZero];
        [_sound2 setTitle:@"两音" forState:UIControlStateNormal];
    }
    return _sound2;
}
-(OtherBtn *) sound3
{
    if (!_sound3) {
        _sound3 = [[OtherBtn alloc] initWithFrame:CGRectZero];
        [_sound3 setTitle:@"三音" forState:UIControlStateNormal];
    }
    return _sound3;
}

-(OtherBtn *)shortBtn
{
    if (!_shortBtn) {
        _shortBtn = [[OtherBtn alloc] initWithFrame:CGRectZero];
        [_shortBtn setTitle:@"短名" forState:UIControlStateNormal];
    }
    return _shortBtn;
}

-(OtherBtn *) longBtn
{
    if (!_longBtn) {
        _longBtn = [[OtherBtn alloc] initWithFrame:CGRectZero];
        [_longBtn setTitle:@"长名" forState:UIControlStateNormal];
    }
    return _longBtn;
}
-(OtherBtn *) confirm
{
    if (!_confirm) {
        _confirm = [[OtherBtn alloc] initWithFrame:CGRectZero];
        [_confirm setTitle:@"取英文名" forState:UIControlStateNormal];
        [_confirm addTarget:self action:@selector(getRsult) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirm;
}
-(void)getRsult
{
    ResultViewController *ctrl = [[ResultViewController alloc] init];
    [self.navigationController pushViewController:ctrl animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

@implementation GenderBtn

-(instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont systemFontOfSize:20];
        [self setTitleColor:RGBCOLOR(0x31, 0xa9, 0xff) forState:UIControlStateSelected];
        [self setTitleColor:RGBCOLOR(0x67, 0xca, 0xf2) forState:UIControlStateNormal];
        [self setSelected:NO];
    };
    return self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    self.layer.cornerRadius = self.frame.size.height/2.0;
}
-(void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    if (selected) {
        self.backgroundColor = [UIColor whiteColor];
    } else {
        self.backgroundColor = RGBCOLOR(0x48, 0xad, 0xd6);
    }
}

@end

@implementation OtherBtn
-(instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont systemFontOfSize:25];
        self.backgroundColor = [UIColor whiteColor];
        [self setTitleColor:RGBCOLOR(0x31, 0xa9, 0xff) forState:UIControlStateNormal];
        [self setTitleColor:RGBCOLOR(0x70, 0xc7, 0xf0) forState:UIControlStateHighlighted];
        
        self.layer.borderWidth = 1;
        self.layer.borderColor = RGBCOLOR(0x4a, 0xcb, 0xe5).CGColor;
        
        self.clipsToBounds = YES;
    }
    return self;
}
-(void) layoutSubviews
{
    [super layoutSubviews];
    self.layer.cornerRadius = self.frame.size.height/4.0;
}
-(void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    if (selected) {
        self.backgroundColor = [UIColor whiteColor];
    } else {
        self.backgroundColor = RGBCOLOR(0x48, 0xad, 0xd6);
    }
}
-(void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    if (highlighted) {
        self.backgroundColor = RGBCOLOR(0x48, 0xad, 0xd6);
    } else {
        self.backgroundColor = [UIColor whiteColor];
    }
}

@end