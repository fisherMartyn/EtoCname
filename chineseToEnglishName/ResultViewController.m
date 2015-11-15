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
        make.top.equalTo(self.view.mas_top).with.offset(70);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-50);
    }];

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
    
    NSPredicate *pred_sex = [NSPredicate predicateWithFormat:@"sexInfo==%@",[genderdict objectForKey:[NSString stringWithFormat:@"%ld",self.sexid]]];
    NSPredicate *pred_sound = [NSPredicate predicateWithFormat:@"chineseNameCnt==%@",[NSNumber numberWithInteger:(self.sounid+1)]]; //soundid+1就是映射
    NSPredicate *pred_length;
    if (self.lengthid == 1) {
        pred_length = [NSPredicate predicateWithFormat:@"englishNameCnt<6"];
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
        combine = [NSCompoundPredicate andPredicateWithSubpredicates:@[pred_sex]];
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
    
    //从第二个汉字获得所有信息
    if (![mfirst isEqualToString:mlast]) {
        request = [[NSFetchRequest alloc] initWithEntityName:@"EnglishNameInfo"];
        request.propertiesToFetch = [NSArray arrayWithObjects:@"chineseName",@"englishName", @"popularCnt", @"sexInfo",@"englishNameCnt",@"chineseNameCnt",@"englishFayin", nil];
        request.returnsDistinctResults = YES;
        
        predictate = [NSPredicate predicateWithFormat:@"pinyinFayin IN %@",self.lastNamePinYins];
        combine = [NSCompoundPredicate andPredicateWithSubpredicates:@[predictate]];
        
        if (self.sexid) {
            combine = [NSCompoundPredicate andPredicateWithSubpredicates:@[predictate,pred_sex]];
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
        combine = [NSCompoundPredicate andPredicateWithSubpredicates:@[pred_sex]];
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
        if (count > 29) {
            break;
        }
        if (inter.count) {
            iter = arc4random()%inter.count;
            [result addObject:[inter objectAtIndex:iter]];
            [inter removeObjectAtIndex:iter];
            ++count;
        }
        if (count > 29) {
            break;
        }
        if (first.count) {
            iter = arc4random()%first.count;
            [result addObject:[first objectAtIndex:iter]];
            [first removeObjectAtIndex:iter];
            ++count;
        }
        if (count >29 ) {
            break;
        }
        if (last.count) {
            iter = arc4random()%last.count;
            [result addObject:[last objectAtIndex:iter]];
            [last removeObjectAtIndex:iter];
            ++count;
        }
        if (count >29 ) {
            break;
        }
        if (popular.count) {
            iter = arc4random()%popular.count;
            [result addObject:[popular objectAtIndex:iter]];
            [popular removeObjectAtIndex:iter];
            ++count;
        }
        if (count >29 ) {
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

@interface PageView()
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *englishNameLabel;
@property (nonatomic,strong) UILabel *cFayinLabel;
@property (nonatomic,strong) UILabel *eFayinLabel;
@property (nonatomic,strong) UIView *popularView;

@end
@implementation PageView

-(instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGBCOLOR(0xd9, 0xee, 0xf6);
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    }
    return self;
}

@end