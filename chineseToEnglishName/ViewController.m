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
#import "Similar.h"
#import "EnglishNameInfo.h"
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
@property (nonatomic,strong) ConfirmBtn *confirm;

@property (nonatomic) NSInteger genderid;
@property (nonatomic) NSInteger soundid;
@property (nonatomic) NSInteger lengthid;

@property (nonatomic,strong) UIActivityIndicatorView * spinner;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /* navi 设置*/
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
    
    
    /* 页面布局 */
    
    WS(ws);
    /* 输入框 */
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ws.view.mas_centerX);
        make.width.equalTo(ws.view.mas_width).with.offset(-120);
        make.top.equalTo(ws.view.mas_top).with.offset(80);
        make.height.mas_equalTo(40);
    }];
    
    /* 两音三音选择 */
    [self.sound2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.view.mas_centerY);
        make.left.equalTo(ws.view.mas_left).with.offset(40);
        make.right.equalTo(ws.middleBtn.mas_centerX).with.offset(-20);
        make.height.mas_equalTo(45);
    }];
    [self.sound3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.sound2.mas_top);
        make.right.equalTo(ws.view.mas_right).with.offset(-40);
        make.left.equalTo(ws.middleBtn.mas_centerX).with.offset(20);
        make.height.mas_equalTo(45);
        
    }];
    
    /* 性别选择 */
    [self.middleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ws.view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(60, 60));
        make.bottom.equalTo(self.sound2.mas_top).with.offset(-20);
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
    
    
    
    /* 名字选择 */
    [self.shortBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.sound2.mas_bottom).with.offset(30);
        make.left.equalTo(ws.view.mas_left).with.offset(40);
        make.right.equalTo(ws.middleBtn.mas_centerX).with.offset(-20);
        make.height.mas_equalTo(45);
    }];
    [self.longBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.shortBtn.mas_top);
        make.right.equalTo(ws.view.mas_right).with.offset(-40);
        make.left.equalTo(ws.middleBtn.mas_centerX).with.offset(20);
        make.height.mas_equalTo(45);
    }];
    
    [self.confirm mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(ws.view.mas_bottom).with.offset(-50);
        make.left.equalTo(ws.view.mas_left).with.offset(50);
        make.right.equalTo(ws.view.mas_right).with.offset(-50);
        make.height.mas_equalTo(40);
    }];
    
    
    
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    

    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *currentAppVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    NSString *previousVersion = [defaults objectForKey:@"appVersion"];
    if (!previousVersion) {
        // first launch
        
        [self firstload];
        [defaults setObject:currentAppVersion forKey:@"appVersion"];
        [defaults synchronize];
    } else if ([previousVersion isEqualToString:currentAppVersion]) {
        // same version
    } else {
        // other version
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:@"clear" forKey:@"firstLoad"]; //use to clear data.
        [self firstload];
        
        [defaults setObject:currentAppVersion forKey:@"appVersion"];
        [defaults synchronize];
    }
    
    
    
    
}
-(void) firstload
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

    NSString *firstload  = [[NSUserDefaults standardUserDefaults] objectForKey:@"firstLoad"];
    if (![firstload isEqualToString:@"loaded"]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.labelText = @"首次打开，加载中";
        
        
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            
            /* 第一次加载时读入数据 */
            [userDefaults setObject:@"loaded" forKey:@"firstLoad"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [self loadData];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hide:YES];
            });
        });
        
    }
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    return [textField resignFirstResponder];
}


-(void) loadData
{
    //从文件里读姓
    [self deleteAllData];
    NSString*filePath=[[NSBundle mainBundle] pathForResource:@"Xing"ofType:@"txt"];
    NSError *error;
    NSString *str = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
    
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSArray *rows = [str componentsSeparatedByString:@"\n"];
    for (NSString *row in rows)
    {
        NSArray *fields = [row componentsSeparatedByString:@"--"];
        NSString *chinese = [fields firstObject];
        
        NSArray *english = [[fields lastObject] componentsSeparatedByString:@"/"];
        for (NSString * word in english) {
            if (![word isEqualToString:@""]) {
                Xing *entry = [NSEntityDescription insertNewObjectForEntityForName:@"Xing" inManagedObjectContext:appdelegate.managedObjectContext];
                [entry setEnglish:word];
                [entry setChinese:chinese];
                
            }
        }
    }
    
    BOOL isSaveSuccess = [appdelegate.managedObjectContext save:&error];
    if (!isSaveSuccess) {
        NSLog(@"Error: %@,%@",error,[error userInfo]);
    }
    
    
    filePath = [[NSBundle mainBundle] pathForResource:@"Similar" ofType:@"txt"];
    str = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
    rows = [str componentsSeparatedByString:@"\n"];
    
    int groupid = 1;
    for (NSString *row  in rows) {
        
        NSArray *fields = [row componentsSeparatedByString:@";"];
        for (NSString* aname in fields) {
            if ([aname isEqualToString:@""]) {
                continue;
            }
            Similar *similar = [NSEntityDescription insertNewObjectForEntityForName:@"Similar" inManagedObjectContext:appdelegate.managedObjectContext];
            [similar setGroupid:[NSNumber numberWithInt:groupid]];
            [similar setC_name:aname];
        }
        ++groupid;
    }
    
    isSaveSuccess = [appdelegate.managedObjectContext save:&error];
    if (!isSaveSuccess) {
        NSLog(@"Error: %@,%@",error,[error userInfo]);
    }
    
    //从文件里读取
    filePath = [[NSBundle mainBundle] pathForResource:@"Info" ofType:@"txt"];
    str = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
    
    rows = [str componentsSeparatedByString:@"\n"];
    
    for (NSString * row in rows) {
        NSArray *fields = [row componentsSeparatedByString:@";"];
        if (fields.count < 7 ) {
            continue;
        }
        NSString *englishName  = [fields objectAtIndex:0];
        NSString *englishNameCnt =[fields objectAtIndex:1];
        NSString *chineseName = [fields objectAtIndex:2];
        NSString *chineseNameCnt = [fields objectAtIndex:3];
        NSString *sexInfo = [fields objectAtIndex:4];
        NSString *englishFayin = [fields objectAtIndex:5];
        NSString *popularCnt = [fields objectAtIndex:6];
        
        if (fields.count >= 8) {
            NSString *pinyin = [fields objectAtIndex:7];
            NSArray *seppinyins = [pinyin componentsSeparatedByString:@","];
            for (NSString *seppinyin in seppinyins) {
                if (![seppinyin isEqualToString:@""]) {
                    EnglishNameInfo *info = [NSEntityDescription insertNewObjectForEntityForName:@"EnglishNameInfo" inManagedObjectContext:appdelegate.managedObjectContext];
                    [info setEnglishName:englishName];
                    [info setEnglishNameCnt:englishNameCnt];
                    [info setChineseName:chineseName];
                    [info setChineseNameCnt:chineseNameCnt];
                    [info setSexInfo:sexInfo];
                    [info setEnglishFayin:englishFayin];
                    [info setPopularCnt:popularCnt];
                    [info setPinyinFayin:seppinyin];
                }
            }
            continue;
        }
        
        NSMutableString *pinyinFayin = [[NSMutableString alloc] initWithString:chineseName];
        
        CFStringTransform((__bridge CFMutableStringRef)pinyinFayin, 0, kCFStringTransformMandarinLatin, NO);
        CFStringTransform((__bridge CFMutableStringRef)pinyinFayin, 0, kCFStringTransformStripDiacritics, NO);
        
        NSArray *pinyin = [pinyinFayin componentsSeparatedByString:@" "];
        for (NSString * comppinyin in pinyin) {
            if (![comppinyin isEqualToString:@""]) {
                EnglishNameInfo *info = [NSEntityDescription insertNewObjectForEntityForName:@"EnglishNameInfo" inManagedObjectContext:appdelegate.managedObjectContext];
                [info setEnglishName:englishName];
                [info setEnglishNameCnt:englishNameCnt];
                [info setChineseName:chineseName];
                [info setChineseNameCnt:chineseNameCnt];
                [info setSexInfo:sexInfo];
                [info setEnglishFayin:englishFayin];
                [info setPopularCnt:popularCnt];
                [info setPinyinFayin:comppinyin];
                
            }
        }
       
    }
    
    isSaveSuccess = [appdelegate.managedObjectContext save:&error];
    if (!isSaveSuccess) {
        NSLog(@"Error: %@,%@",error,[error userInfo]);
    }
    //[self fetchData];
}

-(void) fetchData //for test
{
    //load data
    
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"EnglishNameInfo"];
    NSError *error;
    NSMutableArray *mutableFetchResult = [[appdelegate.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    for (EnglishNameInfo *entry in mutableFetchResult) {
        NSLog(@"%@ - %@ - %@",entry.englishName,entry.pinyinFayin,entry.chineseName);
    }
}

-(void)deleteAllData
{
    [self deleteDataByEntityName:@"Xing"];
    [self deleteDataByEntityName:@"Similar"];
    [self deleteDataByEntityName:@"EnglishNameInfo"];
}
-(void) deleteDataByEntityName:(NSString *)entityName
{
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:entityName];
    [request setIncludesPropertyValues:NO];
    NSError *error;
    NSArray *fetchedObjects = [appdelegate.managedObjectContext executeFetchRequest:request error:&error];
    for (NSManagedObject *object in fetchedObjects)
    {
        [appdelegate.managedObjectContext deleteObject:object];
    }
    
    error = nil;
    [appdelegate.managedObjectContext save:&error];
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
        _textView.delegate = self;
        
    }
    return _textView;
}

-(void) GenderSelect:(GenderBtn *)sender
{
    if (sender.tag == self.genderid) {
        [sender setSelected:NO];
        self.genderid = 0;
    } else {
        [self.leftBtn setSelected:NO];
        [self.middleBtn setSelected:NO];
        [self.rightBtn setSelected:NO];
        [sender setSelected:YES];
        self.genderid = sender.tag;
    }
}
-(void) soundSelect:(OtherBtn *)sender
{
    if (sender.tag == self.soundid) {
        [sender setSelected:NO];
        self.soundid = 0;
    } else {
        [self.sound2 setSelected:NO];
        [self.sound3 setSelected:NO];
        [sender setSelected:YES];
        self.soundid = sender.tag;
    }
}
-(void) lengthSelect:(OtherBtn *)sender
{
    if (sender.tag == self.lengthid) {
        [sender setSelected:NO];
        self.lengthid = 0;
    } else {
        [self.shortBtn setSelected:NO];
        [self.longBtn setSelected:NO];
        [sender setSelected:YES];
        self.lengthid = sender.tag;
    }
}

-(GenderBtn*) leftBtn
{
    if (!_leftBtn) {
        _leftBtn = [[GenderBtn alloc] initWithFrame:CGRectZero];
        [_leftBtn setTitle:@"女" forState:UIControlStateNormal];
        [_leftBtn setTitle:@"女" forState:UIControlStateSelected];
        [_leftBtn addTarget:self action:@selector(GenderSelect:) forControlEvents:UIControlEventTouchUpInside];
        _leftBtn.tag = 1;
    }
    return _leftBtn;
}
-(GenderBtn *)middleBtn
{
    if (!_middleBtn) {
        _middleBtn = [[GenderBtn alloc] initWithFrame:CGRectZero];
        [_middleBtn setTitle:@"中性" forState:UIControlStateNormal];
        [_middleBtn setTitle:@"中性" forState:UIControlStateSelected];
        _middleBtn.tag = 2;
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
        _rightBtn.tag = 3;
        [_rightBtn addTarget:self action:@selector(GenderSelect:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBtn;
}

-(OtherBtn *) sound2
{
    if (!_sound2) {
        _sound2 = [[OtherBtn alloc] initWithFrame:CGRectZero];
        _sound2.tag = 1;
        [_sound2 setTitle:@"两音" forState:UIControlStateNormal];
        [_sound2 addTarget:self action:@selector(soundSelect:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sound2;
}
-(OtherBtn *) sound3
{
    if (!_sound3) {
        _sound3 = [[OtherBtn alloc] initWithFrame:CGRectZero];
        [_sound3 setTitle:@"三音" forState:UIControlStateNormal];
        [_sound3 addTarget:self action:@selector(soundSelect:) forControlEvents:UIControlEventTouchUpInside];
        _sound3.tag = 2;
    }
    return _sound3;
}

-(OtherBtn *)shortBtn
{
    if (!_shortBtn) {
        _shortBtn = [[OtherBtn alloc] initWithFrame:CGRectZero];
        [_shortBtn setTitle:@"短名" forState:UIControlStateNormal];
        _shortBtn.tag = 1;
        [_shortBtn addTarget:self action:@selector(lengthSelect:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shortBtn;
}

-(OtherBtn *) longBtn
{
    if (!_longBtn) {
        _longBtn = [[OtherBtn alloc] initWithFrame:CGRectZero];
        [_longBtn setTitle:@"长名" forState:UIControlStateNormal];
        _longBtn.tag = 2;
        [_longBtn addTarget:self action:@selector(lengthSelect:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _longBtn;
}
-(ConfirmBtn *) confirm
{
    if (!_confirm) {
        _confirm = [[ConfirmBtn alloc] initWithFrame:CGRectZero];
        [_confirm setTitle:@"取英文名" forState:UIControlStateNormal];
        [_confirm addTarget:self action:@selector(getRsult) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirm;
}
-(void)getRsult
{
    ResultViewController *ctrl = [[ResultViewController alloc] init];
    ctrl.name = self.textView.text;
    ctrl.sexid = self.genderid;
    ctrl.sounid = self.soundid;
    ctrl.lengthid =self.lengthid;
    if (![ctrl.name isEqualToString:@""] && (ctrl.name.length >1)) {
        [self.navigationController pushViewController:ctrl animated:YES];
    } else {
        [self.view makeToast:@"姓和名不得为空" duration:1.0 position:CSToastPositionCenter];
    }
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
        self.titleLabel.font = [UIFont systemFontOfSize:23];
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
        self.titleLabel.font = [UIFont systemFontOfSize:20];
        self.backgroundColor = RGBCOLOR(0x48, 0xad, 0xd6);
        [self setTitleColor:RGBCOLOR(0x74, 0xd1, 0xfa) forState:UIControlStateNormal];
        [self setTitleColor:RGBCOLOR(0x70, 0xc7, 0xf0) forState:UIControlStateHighlighted];
        
        self.layer.borderWidth = 2;
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
        self.layer.borderColor  =[UIColor whiteColor].CGColor;
    } else {
        self.backgroundColor = RGBCOLOR(0x48, 0xad, 0xd6);
        self.layer.borderColor = RGBCOLOR(0x4a, 0xcb, 0xe5).CGColor;
    }
}

@end

@implementation ConfirmBtn
-(instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont systemFontOfSize:25];
        self.backgroundColor = RGBCOLOR(0xd1, 0xeb, 0xf4);
        [self setTitleColor:RGBCOLOR(0x74, 0xd1, 0xfa) forState:UIControlStateNormal];
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

 -(void)setHighlighted:(BOOL)highlighted
 {
     [super setHighlighted:highlighted];
     if (highlighted) {
         self.backgroundColor = RGBCOLOR(0x64, 0xad, 0xd6);
     } else {
         self.backgroundColor = RGBCOLOR(0xd1, 0xeb, 0xf4);
     }
 }

@end