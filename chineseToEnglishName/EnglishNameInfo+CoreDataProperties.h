//
//  EnglishNameInfo+CoreDataProperties.h
//  chineseToEnglishName
//
//  Created by yujixing on 15/11/14.
//  Copyright © 2015年 YM. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "EnglishNameInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface EnglishNameInfo (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *chineseName;
@property (nullable, nonatomic, retain) NSString *englishName;
@property (nullable, nonatomic, retain) NSString *fayin;
@property (nullable, nonatomic, retain) NSNumber *popularCnt;
@property (nullable, nonatomic, retain) NSNumber *pronunceCnt;
@property (nullable, nonatomic, retain) NSNumber *sexInfo;

@end

NS_ASSUME_NONNULL_END
