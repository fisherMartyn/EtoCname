//
//  ResultViewController.h
//  chineseToEnglishName
//
//  Created by yujixing on 15/11/14.
//  Copyright © 2015年 YM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResultViewController : UIViewController

@property (nonatomic,strong) NSString *name;
@property (nonatomic) NSInteger sexid;
@property (nonatomic) NSInteger sounid;
@property (nonatomic) NSInteger lengthid;

@end

@interface ResultScrollView : UIScrollView

@end

@interface PageView : UIView
@property (nonatomic,strong) NSString *Name;
@property (nonatomic,strong) NSString *englishName;
@property (nonatomic,strong) NSString *englishFayin;
@property (nonatomic,strong) NSString *chineseFayin;//汉字读音
@property (nonatomic) int popular;

@end