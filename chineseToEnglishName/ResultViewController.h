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

-(instancetype) initWithFrame:(CGRect)frame and:(NSString *)name andEnglish:(NSString *)englishName andEFayin:(NSString *)englishFayin andCFayin:(NSString *)chineseFayin andPopular:(int)popular;

@end

@interface BackButton : UIControl
-(instancetype) initWithFrame:(CGRect)frame title:(NSString*)title;

@end

@interface NSString (DeviceType) //仅仅根据高度做区分
+(NSString*)currentType;
@end
