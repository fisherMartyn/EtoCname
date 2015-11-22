//
//  ResultViewController.m
//  chineseToEnglishName
//
//  Created by yujixing on 15/11/14.
//  Copyright © 2015年 YM. All rights reserved.
//

#import "ResultViewController.h"
#import "RelateWorkViewController.h"
#import "EnglishNameInfo.h"
#import "AppDelegate.h"
#import <Masonry.h>
#import "Xing.h"
#import "Similar.h"
#import <ShareSDK/ShareSDK.h>

@interface ResultViewController ()

@property (nonatomic,strong) NSMutableArray *xings;
//各个拼音极其相似集合
@property (nonatomic,strong) NSMutableArray *firstNamePinYins;
@property (nonatomic,strong) NSMutableArray *lastNamePinYins;

//第一个字和第二个字查出来的全集
@property (nonatomic,strong) NSMutableArray *firstMings;
@property (nonatomic,strong) NSMutableArray *lastMings;

@property (nonatomic,strong) NSArray *onlyfirst;
@property (nonatomic,strong) NSArray *onlylast;
@property (nonatomic,strong) NSArray *intersects;
@property (nonatomic,strong) NSArray *allpopular;

//排序后用于显示的数组
@property (nonatomic,strong) NSMutableArray *shownArr;

@property (nonatomic,strong) ResultScrollView *scrollview;

@property (nonatomic,strong) UIToolbar *toolBar;
@property (nonatomic,strong) UIBarButtonItem *barItem;
@property (nonatomic,strong) UIView *popUpView;
@end

@implementation ResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor  = BGCOLOR;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    UIBarButtonItem * stats = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"stats"] style:UIBarButtonItemStylePlain target:self action:@selector(showStatsAction)];
    self.navigationItem.rightBarButtonItem = stats;
    
    
    BackButton *leftview = [[BackButton alloc] initWithFrame:CGRectMake(0, 0, 100, 22) title:@"重新取名"];
    [leftview addTarget:self action:@selector(goback) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftitem = [[UIBarButtonItem alloc] initWithCustomView:leftview];
    self.navigationItem.leftBarButtonItem = leftitem;
    /*
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithTitle:@"重新取名" style:UIBarButtonItemStylePlain target:self action:@selector(goback)];
    self.navigationItem.leftBarButtonItem = left;
    */
    self.scrollview = [[ResultScrollView alloc] initWithFrame:CGRectZero];
    self.scrollview.backgroundColor = [UIColor clearColor];
    
    
    WS(ws);
    [self.view addSubview:self.scrollview];
    [self.scrollview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws.view.mas_left);
        make.right.equalTo(ws.view.mas_right);
        make.top.equalTo(ws.view.mas_top).with.offset(10);
        make.bottom.equalTo(ws.view.mas_bottom).with.offset(-50);
        
    }];
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    
    [self.view addSubview:self.toolBar];
    [self.toolBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ws.view.mas_centerX);
        make.width.equalTo(ws.view.mas_width);
        make.height.mas_equalTo(50);
        make.bottom.mas_equalTo(ws.view.mas_bottom).with.offset(-10);
    }];
    
    
    [self.view addSubview:self.popUpView];
    [self.popUpView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@20);
        make.height.equalTo(@20);
        make.bottom.equalTo(ws.view.mas_bottom).with.offset(-60);
        make.centerX.equalTo(ws.view.mas_centerX);
    }];
    
}
-(void) goback
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
-(UIView *) popUpView
{
    if (!_popUpView) {
        _popUpView = [UIView new];
        _popUpView.backgroundColor = [UIColor clearColor];
    }
    return _popUpView;
}

-(UIImage *) screenShot {
    UIGraphicsBeginImageContext([UIScreen mainScreen].bounds.size);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

-(void) popback
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(UIToolbar*) toolBar {
    if (!_toolBar) {
        _toolBar = [[UIToolbar alloc] initWithFrame:CGRectZero];
        [_toolBar setBackgroundImage:[[UIImage alloc] init] forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
        _toolBar.clipsToBounds = YES;
        //颜色：渲染toolbar
        _toolBar.tintColor =  [UIColor whiteColor];
        
        UIBarButtonItem *flexibleSpace =  [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        _toolBar.items = @[flexibleSpace,self.barItem,flexibleSpace];
    }
    return _toolBar;
}

-(UIBarButtonItem *)barItem {
    if (!_barItem) {
        _barItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(shareAction:)];
        //[_barItem setTitle:@"返回"];
    }
    return _barItem;
}


-(void) shareAction:(id)sender
{
    
    UIImage *img = [self screenShot];
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:@"根据中文名取英文名"
                                       defaultContent:@"根据中文名取英文名"
                                                image:[ShareSDK jpegImageWithImage:img quality:1]
                                                title:@"取英文名"
                                                  url:@"http://weibo.com/5580956204"
                                          description:@"根据中文名取英文名"
                                            mediaType:SSPublishContentMediaTypeImage];
    //创建iPad弹出菜单容器,详见第六步
    id<ISSContainer> container = [ShareSDK container];
    [container setIPadContainerWithView:self.popUpView arrowDirect:UIPopoverArrowDirectionUp];
    
    //弹出分享菜单
    [ShareSDK showShareActionSheet:container
                         shareList:nil
                           content:publishContent
                     statusBarTips:NO
                       authOptions:nil
                      shareOptions:nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                
                                if (state == SSResponseStateSuccess)
                                {
                                    NSLog(@"分享成功");
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    NSLog(@"分享失败,错误码:%ld,错误描述:%@", (long)[error errorCode], [error errorDescription]);
                                }
                            }];
    /*
    NSArray *arr = [NSArray arrayWithObjects:[self screenShot], nil];
    UIActivityViewController* vc = [[UIActivityViewController alloc]
                                    initWithActivityItems:arr applicationActivities:nil];
    vc.excludedActivityTypes = @[UIActivityTypeAssignToContact];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [self presentViewController:vc animated:YES completion:nil];
    }
    else {
        vc.modalPresentationStyle = UIModalPresentationPopover;
        vc.popoverPresentationController.sourceRect = CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height-50, 1, 1);
        [self presentViewController:vc animated:YES completion:nil];
        UIPopoverController *popup = [[UIPopoverController alloc] initWithContentViewController:vc];
        [popup presentPopoverFromBarButtonItem:self.barItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }*/
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.xings = [NSMutableArray array];
    self.firstMings = [NSMutableArray array];
    self.lastMings = [NSMutableArray array];
    self.firstNamePinYins = [NSMutableArray array];
    self.lastNamePinYins = [NSMutableArray array];
    self.shownArr = [NSMutableArray array];
    [self searchName];
    [self orderNames];
   
    NSString *xing;
    
    if (self.xings.count) {
        xing = [self.xings objectAtIndex:(arc4random()%self.xings.count)];
    } else {
        xing = @"";
    }
    
    
    NSInteger count = self.shownArr.count;
    self.scrollview.contentSize =CGSizeMake(self.view.frame.size.width*count, self.view.frame.size.height-80-64);
    
    for (int i=0; i<count; ++i) {
        EnglishNameInfo *info = [self.shownArr objectAtIndex:i];
        PageView *page;
        //iphone
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            page = [[PageView alloc] initWithFrame:CGRectMake(i*self.view.frame.size.width + 40, 0, self.view.frame.size.width-80, self.scrollview.contentSize.height -10) and:self.name andEnglish:[NSString stringWithFormat:@"%@ %@",info.englishName,xing] andEFayin:info.englishFayin andCFayin:info.chineseName andPopular:info.popularCnt.intValue];
        } else {
        //ipad在这里调
            page = [[PageView alloc] initWithFrame:CGRectMake(i*self.view.frame.size.width + 160, 120, self.view.frame.size.width-320, self.scrollview.contentSize.height -220) and:self.name andEnglish:[NSString stringWithFormat:@"%@ %@",info.englishName,xing] andEFayin:info.englishFayin andCFayin:info.chineseName andPopular:info.popularCnt.intValue];
        }
        [self.scrollview addSubview:page];
    }
    
}

-(void) searchName
{
    NSRange range;
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Xing"];
    NSError *error;
    
    
    //进行过滤条件的判断
    NSMutableDictionary *genderdict = [[NSMutableDictionary alloc] init];
    [genderdict setObject:@"全部" forKey:@"0"];
    [genderdict setObject:@"女性" forKey:@"1"];
    [genderdict setObject:@"中性" forKey:@"2"];
    [genderdict setObject:@"男性" forKey:@"3"];
    
    NSPredicate *pred_sex = [NSPredicate predicateWithFormat:@"sexInfo==%@",[genderdict objectForKey:[NSString stringWithFormat:@"%ld",(long)self.sexid]]];
    NSPredicate *pred_sound = [NSPredicate predicateWithFormat:@"chineseNameCnt==%@",[NSNumber numberWithInteger:(self.sounid+1)]]; //soundid+1就是映射
    NSPredicate *pred_length;
    if (self.lengthid == 1) {
        pred_length = [NSPredicate predicateWithFormat:@"englishNameCnt<=6"];
    } else if (self.lengthid == 2) {
        pred_length = [NSPredicate predicateWithFormat:@"englishNameCnt>6"];
    }
    
    //长度大于2的才判断复姓
    NSString *substr;
    if (self.name.length > 2) {
        range.location = 0;
        range.length  = 2;
        substr = [self.name substringWithRange:range];
    }
    NSPredicate *predictate = [NSPredicate predicateWithFormat:@"chinese==%@",substr];
    request.predicate = predictate;
    NSMutableArray *mutableFetchResult = [[appdelegate.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    //首先查找复姓，没有复姓才看单姓
    if (mutableFetchResult.count > 0) {
        for (Xing *entry in mutableFetchResult) {
            [self.xings addObject:entry.english];
        }
        
    } else {
        if (self.name.length > 1) {
            range.location = 0;
            range.length = 1;
            substr = [self.name substringWithRange:range];
        }
        predictate = [NSPredicate predicateWithFormat:@"chinese==%@",substr];
        request.predicate = predictate;
        NSMutableArray *mutableFetchResult = [[appdelegate.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
        for (Xing *entry in mutableFetchResult) {
            [self.xings addObject:entry.english];
        }
        
    }
    
    
    
    //获取名字的两个字段
    NSString *ming = [self.name substringFromIndex:range.length];
    NSString *first = NULL;
    NSString *last = NULL;
    first = [ming substringToIndex:1];
    last = [ming substringFromIndex:ming.length-1];
    NSMutableString *mfirst = [[NSMutableString alloc] initWithString:first];
    NSMutableString *mlast = [[NSMutableString alloc] initWithString:last];
    CFStringTransform((__bridge CFMutableStringRef)mfirst, 0, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((__bridge CFMutableStringRef)mfirst, 0, kCFStringTransformStripDiacritics, NO);
    CFStringTransform((__bridge CFMutableStringRef)mlast, 0, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((__bridge CFMutableStringRef)mlast, 0, kCFStringTransformStripDiacritics, NO);
    
    
    
    
    
    //查出两个名字对应的所有拼音
    request = [[NSFetchRequest alloc] initWithEntityName:@"Similar"];
    predictate = [NSPredicate predicateWithFormat:@"c_name==%@",mfirst];
    request.predicate = predictate;
    NSMutableArray *results = [[appdelegate.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    Similar *similar = [results firstObject];
    if (similar) {
        predictate = [NSPredicate predicateWithFormat:@"groupid==%@",similar.groupid];
        request.predicate = predictate;
        NSMutableArray *result= [[appdelegate.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
        for (Similar *asim in result) {
            [self.firstNamePinYins insertObject:asim.c_name atIndex:0];
        }
    } else {
        [self.firstNamePinYins insertObject:mfirst atIndex:0];
    }
    
    if (![mfirst isEqualToString:mlast]) {
        request = [[NSFetchRequest alloc] initWithEntityName:@"Similar"];
        predictate = [NSPredicate predicateWithFormat:@"c_name==%@",mlast];
        request.predicate = predictate;
        NSMutableArray *results = [[appdelegate.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
        Similar *similar = [results firstObject];
        if (similar) {
            predictate = [NSPredicate predicateWithFormat:@"groupid==%@",similar.groupid];
            request.predicate = predictate;
            NSMutableArray *result= [[appdelegate.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
            for (Similar *asim in result) {
                [self.lastNamePinYins insertObject:asim.c_name atIndex:0];
            }
        } else {
            [self.lastNamePinYins insertObject:mlast atIndex:0];
        }
    }
    
    
    
    //从第一个汉字中获得所有信息
    request = [[NSFetchRequest alloc] initWithEntityName:@"EnglishNameInfo"];
    request.propertiesToFetch = [NSArray arrayWithObjects:@"chineseName",@"englishName", @"popularCnt", @"sexInfo",@"englishNameCnt",@"chineseNameCnt",@"englishFayin", nil];
    request.returnsDistinctResults = YES;
    
    

    predictate = [NSPredicate predicateWithFormat:@"pinyinFayin IN %@",self.firstNamePinYins];
    
    NSPredicate *combine = NULL;
    combine = [NSCompoundPredicate andPredicateWithSubpredicates:@[predictate]];
    if (self.sexid) {
        combine = [NSCompoundPredicate andPredicateWithSubpredicates:@[combine,pred_sex]];
    }
    if (self.sounid) {
        combine = [NSCompoundPredicate andPredicateWithSubpredicates:@[combine,pred_sound]];
    }
    if (self.lengthid) {
        combine = [NSCompoundPredicate andPredicateWithSubpredicates:@[combine,pred_length]];
    }
    request.predicate = combine;
    
    results = [[appdelegate.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    self.firstMings =results;
    
    /*
    for (EnglishNameInfo *tinfo in results) {
        NSLog(@"%@ -- %@", tinfo.englishName, tinfo.chineseName);
    }
     */
    
    //从第二个汉字获得所有信息
    if (![mfirst isEqualToString:mlast]) {
        request = [[NSFetchRequest alloc] initWithEntityName:@"EnglishNameInfo"];
        request.propertiesToFetch = [NSArray arrayWithObjects:@"chineseName",@"englishName", @"popularCnt", @"sexInfo",@"englishNameCnt",@"chineseNameCnt",@"englishFayin", nil];
        request.returnsDistinctResults = YES;
        
        predictate = [NSPredicate predicateWithFormat:@"pinyinFayin IN %@",self.lastNamePinYins];
        combine = [NSCompoundPredicate andPredicateWithSubpredicates:@[predictate]];
        
        if (self.sexid) {
            combine = [NSCompoundPredicate andPredicateWithSubpredicates:@[combine,pred_sex]];
        }
        if (self.sounid) {
            combine = [NSCompoundPredicate andPredicateWithSubpredicates:@[combine,pred_sound]];
        }
        if (self.lengthid) {
            combine = [NSCompoundPredicate andPredicateWithSubpredicates:@[combine,pred_length]];
        }
        request.predicate = combine;
        
        results = [[appdelegate.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
        self.lastMings =results;
    }
    
    
    
    
    //获取交集
    NSMutableSet *intersetct = [NSMutableSet setWithArray:self.firstMings];
    NSMutableSet *slice = [NSMutableSet setWithArray:self.lastMings];
    [intersetct intersectSet:slice];
    NSArray *inter1 = [intersetct allObjects];
    self.intersects =  inter1;
    
    intersetct = [NSMutableSet setWithArray:self.firstMings];
    slice = [NSMutableSet setWithArray:inter1];
    [intersetct minusSet:slice];
    NSArray *onlyfirst = [intersetct allObjects];
    self.onlyfirst = onlyfirst;
    
    intersetct = [NSMutableSet setWithArray:self.lastMings];
    slice = [NSMutableSet setWithArray:inter1];
    [intersetct minusSet:slice];
    self.onlylast = [intersetct allObjects];
    
    
    /*
    NSLog(@"intersects");
    for (EnglishNameInfo *f in self.intersects) {
        NSLog(@"%@ -- %@", f.pinyinFayin, f.englishName);
    }
    
    NSLog(@"first");
    for (EnglishNameInfo *f in self.onlyfirst) {
        NSLog(@"%@ -- %@", f.pinyinFayin, f.englishName);
    }
    
    NSLog(@"last");
    for (EnglishNameInfo *f in self.onlylast) {
        NSLog(@"%@ -- %@", f.pinyinFayin, f.englishName);
    }
     */
    
    
    //从popular中查找
    
    request = [[NSFetchRequest alloc] initWithEntityName:@"EnglishNameInfo"];
    request.propertiesToFetch = [NSArray arrayWithObjects:@"chineseName",@"englishName", @"popularCnt", @"sexInfo",@"englishNameCnt",@"chineseNameCnt",@"englishFayin", nil];
    request.returnsDistinctResults = YES;
    predictate = [NSPredicate predicateWithFormat:@"popularCnt >3"];
    
    combine = [NSCompoundPredicate andPredicateWithSubpredicates:@[predictate]];
    if (self.sexid) {
        combine = [NSCompoundPredicate andPredicateWithSubpredicates:@[combine,pred_sex]];
    }
    if (self.sounid) {
        combine = [NSCompoundPredicate andPredicateWithSubpredicates:@[combine,pred_sound]];
    }
    if (self.lengthid) {
        combine = [NSCompoundPredicate andPredicateWithSubpredicates:@[combine,pred_length]];
    }
    request.predicate = combine;
    
    results = [[appdelegate.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    
    NSMutableSet *popular = [NSMutableSet setWithArray:results];
    NSMutableSet *allfirst = [NSMutableSet setWithArray:self.firstMings];
    NSMutableSet *alllast = [NSMutableSet setWithArray:self.lastMings];
    
    [popular minusSet:allfirst];
    [popular minusSet:alllast];
    
    self.allpopular = [popular allObjects];
    
}

-(void) orderNames
{
    NSMutableArray *inter = [NSMutableArray arrayWithArray:self.intersects];
    NSMutableArray *first = [NSMutableArray arrayWithArray:self.onlyfirst];
    NSMutableArray *last = [NSMutableArray arrayWithArray:self.onlylast];
    NSMutableArray *popular = [NSMutableArray arrayWithArray:self.allpopular];
    
    int count = 0;
    int iter;
    NSMutableArray *result = [NSMutableArray array];
    while (1) {
        if (inter.count) {
            iter = arc4random()%inter.count;
            [result addObject:[inter objectAtIndex:iter]];
            [inter removeObjectAtIndex:iter];
            ++count;
        }
        if (count > 59) {
            break;
        }
        if (inter.count) {
            iter = arc4random()%inter.count;
            [result addObject:[inter objectAtIndex:iter]];
            [inter removeObjectAtIndex:iter];
            ++count;
        }
        if (count > 59) {
            break;
        }
        if (first.count) {
            iter = arc4random()%first.count;
            [result addObject:[first objectAtIndex:iter]];
            [first removeObjectAtIndex:iter];
            ++count;
        }
        if (count >59 ) {
            break;
        }
        if (last.count) {
            iter = arc4random()%last.count;
            [result addObject:[last objectAtIndex:iter]];
            [last removeObjectAtIndex:iter];
            ++count;
        }
        if (count >59 ) {
            break;
        }
        if (popular.count) {
            iter = arc4random()%popular.count;
            [result addObject:[popular objectAtIndex:iter]];
            [popular removeObjectAtIndex:iter];
            ++count;
        }
        if (count >59 ) {
            break;
        }
        if (inter.count == 0 && first.count == 0 && last.count == 0 && popular.count == 0 ) {
            break;
        }
    }
    self.shownArr = result;
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
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.pagingEnabled = YES;
        self.bounces = NO;
    }
    return self;
}

@end

@interface PageView()
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *englishNameLabel;
@property (nonatomic,strong) UILabel *eFayinLabel;
@property (nonatomic,strong) UILabel *cFayinLabel;
@property (nonatomic,strong) UIView *popularLabel;
@property (nonatomic,strong) UILabel *textLabel;
@property (nonatomic,strong) NSMutableArray *stars;

@end
@implementation PageView

-(instancetype) initWithFrame:(CGRect)frame and:(NSString *)name andEnglish:(NSString *)englishName andEFayin:(NSString *)englishFayin andCFayin:(NSString *)chineseFayin andPopular:(int)popular
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGBCOLOR(0xd9, 0xee, 0xf6);
        
        self.clipsToBounds = YES;
        self.layer.cornerRadius = 10;
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.nameLabel.text = name;
        self.nameLabel.textAlignment =NSTextAlignmentCenter;
        self.nameLabel.textColor = RGBCOLOR(0x4a, 0xb3, 0xfd);
        self.nameLabel.font = [UIFont systemFontOfSize:30];
        self.nameLabel.backgroundColor = RGBCOLOR(0xe3, 0xf2, 0xf8);
        self.nameLabel.clipsToBounds = YES;
        self.nameLabel.layer.cornerRadius = 8;
        [self addSubview:self.nameLabel];
        WS(ws);
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {

            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
                if ([[NSString currentType] isEqualToString:@"iPhone4"]) {
                    make.top.equalTo(ws.mas_top).with.offset(10);
                } else {
                    make.top.equalTo(ws.mas_top).with.offset(60);
                }
            }else{//iPad时显示的姓名离顶部远点
                make.top.equalTo(ws.mas_top).with.offset(140);
            }
            
            make.width.equalTo(ws.mas_width).with.offset(-80);
            make.height.equalTo(@45);
            make.centerX.equalTo(ws.mas_centerX);
        }];
        
        self.englishNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.englishNameLabel.text = englishName;
        self.englishNameLabel.textAlignment = NSTextAlignmentCenter;
        self.englishNameLabel.textColor = self.nameLabel.textColor;
        self.englishNameLabel.font = [UIFont systemFontOfSize:30];
        self.englishNameLabel.backgroundColor = self.nameLabel.backgroundColor;
        self.englishNameLabel.layer.cornerRadius = 8;
        self.englishNameLabel.clipsToBounds = YES;
        [self addSubview:self.englishNameLabel];
        [self.englishNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(ws.nameLabel.mas_bottom).with.offset(20);
            make.width.equalTo(ws.nameLabel.mas_width).with.offset(-5);
            make.height.equalTo(@45);
            make.centerX.equalTo(ws.mas_centerX);
        }];
        self.englishNameLabel.adjustsFontSizeToFitWidth = YES;

        
        
        self.eFayinLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.eFayinLabel.text = englishFayin;
        self.eFayinLabel.textAlignment = NSTextAlignmentCenter;
        self.eFayinLabel.textColor = self.nameLabel.textColor;
        self.eFayinLabel.font = [UIFont systemFontOfSize:25];
        self.eFayinLabel.backgroundColor = self.nameLabel.backgroundColor;
        self.eFayinLabel.layer.cornerRadius = 8;
        self.eFayinLabel.clipsToBounds = YES;
        [self addSubview:self.eFayinLabel];
        [self.eFayinLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(ws.englishNameLabel.mas_bottom).with.offset(20);
            make.width.equalTo(ws.mas_width).with.offset(-100);
            make.height.mas_equalTo(45);
            make.centerX.equalTo(ws.mas_centerX);
        }];
        
        self.cFayinLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.cFayinLabel.text = chineseFayin;
        self.cFayinLabel.textAlignment = NSTextAlignmentCenter;
        self.cFayinLabel.textColor  = self.nameLabel.textColor;
        self.cFayinLabel.font = [UIFont systemFontOfSize:22];
        self.cFayinLabel.backgroundColor = self.nameLabel.backgroundColor;
        self.cFayinLabel.layer.cornerRadius = 8;
        self.cFayinLabel.clipsToBounds = YES;
        [self addSubview:self.cFayinLabel];
        [self.cFayinLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(ws.eFayinLabel.mas_bottom).with.offset(20);
            make.width.equalTo(ws.mas_width).with.offset(-100);
            make.height.mas_equalTo(40);
            make.centerX.equalTo(ws.mas_centerX);
        }];
        
        self.popularLabel = [[UIView alloc] initWithFrame:CGRectZero];
        [self addSubview:self.popularLabel];
        self.popularLabel.backgroundColor = self.cFayinLabel.backgroundColor;
        self.popularLabel.layer.cornerRadius = 8;
        self.popularLabel.clipsToBounds = YES;
        [self.popularLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(ws.cFayinLabel.mas_bottom).with.offset(20);
            make.width.equalTo(ws.mas_width).with.offset(-80);
            make.height.mas_equalTo(40);
            make.centerX.equalTo(ws.mas_centerX);
        }];
        
        self.textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.textLabel.text = @"流行度：";
        //self.textLabel.textAlignment = NSTextAlignmentRight;
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        
        self.textLabel.backgroundColor = [UIColor clearColor];
        self.textLabel.textColor = self.nameLabel.textColor;
        self.textLabel.font = [UIFont systemFontOfSize:20];
        self.textLabel.layer.cornerRadius = 8;
        self.textLabel.clipsToBounds = YES;
        [self addSubview:self.textLabel];
        [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(ws.popularLabel.mas_top);
            make.right.equalTo(ws.mas_centerX).with.offset(-20);
            make.height.mas_equalTo(40);
            make.width.equalTo(@80);
        }];
    
        self.stars = [NSMutableArray array];
        for (int i =0 ; i< popular; i++) {
            UIImageView *v = [[UIImageView alloc] initWithFrame:CGRectZero];
            v.contentMode = UIViewContentModeScaleToFill;
            v.image = [UIImage imageNamed:@"star.png"];
            [self addSubview:v];
            [self.stars addObject:v];
        }
        
        UIImageView *v  = [self.stars objectAtIndex:0];
        [v mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(ws.textLabel.mas_right);
            make.height.equalTo(@25);
            make.width.equalTo(@25);
            make.centerY.equalTo(ws.textLabel.mas_centerY);
        }];
        
        for (int i =1 ; i<popular; i++) {
            
            UIImageView *v  = [self.stars objectAtIndex:i];
            UIImageView *pre = [self.stars objectAtIndex:i-1];
            [v mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(pre.mas_right);
                make.top.equalTo(pre.mas_top);
                make.height.equalTo(pre.mas_height);
                make.width.equalTo(pre.mas_width);
            }];
        }
        
        
    }
    return self;
    
}

@end
@implementation BackButton

-(instancetype) initWithFrame:(CGRect)frame title:(NSString*)title;
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectZero];
        img.contentMode = UIViewContentModeScaleToFill;
        img.image = [UIImage imageNamed:@"back.png"];
        WS(ws);
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.textAlignment = NSTextAlignmentLeft;
        label.textColor = [UIColor whiteColor];
        label.text = title;
        label.font = [UIFont systemFontOfSize:16];
        
        [self addSubview:img];
        [self addSubview:label];
        [img mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(ws.mas_height);
            make.left.equalTo(ws.mas_left).with.offset(-14);
            make.top.equalTo(ws.mas_top);
            make.width.equalTo(img.mas_height);
        }];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(ws.mas_height);
            make.left.equalTo(img.mas_right).with.offset(0);
            make.top.equalTo(ws.mas_top);
            make.width.equalTo(ws.mas_width).with.offset(22);
        }];
    }
    return self;
    
}

@end

@implementation NSString (DeviceType)
+(NSString *)currentType
{
    NSString *preName;
    if (480.0f == [UIScreen mainScreen].bounds.size.height) {
        preName = @"iPhone4";
    }else if (568.0f == [UIScreen mainScreen].bounds.size.height) {
        preName = @"iPhone5";
    } else if (667.0f == [UIScreen mainScreen].bounds.size.height){
        preName  = @"iPhone6";
    } else{
        preName = @"iPhone6p";
    }
    return preName;
}
@end
