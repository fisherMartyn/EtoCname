//
//  Ming+CoreDataProperties.h
//  chineseToEnglishName
//
//  Created by yujixing on 15/11/14.
//  Copyright © 2015年 YM. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Ming.h"

NS_ASSUME_NONNULL_BEGIN

@interface Ming (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *chinese;
@property (nullable, nonatomic, retain) NSString *english;

@end

NS_ASSUME_NONNULL_END
