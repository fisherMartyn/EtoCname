//
//  Similar+CoreDataProperties.h
//  chineseToEnglishName
//
//  Created by yujixing on 15/11/14.
//  Copyright © 2015年 YM. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Similar.h"

NS_ASSUME_NONNULL_BEGIN

@interface Similar (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *c_name;
@property (nullable, nonatomic, retain) NSNumber *groupid;

@end

NS_ASSUME_NONNULL_END
