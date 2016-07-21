//
//  Goals+CoreDataProperties.h
//  Mastery 10,000 Hours
//
//  Created by Andrey Bevilacqua on 7/6/16.
//  Copyright © 2016 Andrey Bevilacqua. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Goals.h"

NS_ASSUME_NONNULL_BEGIN

@interface Goals (CoreDataProperties)

@property (nullable, nonatomic, retain) NSDate *creation_Date;
@property (nullable, nonatomic, retain) NSNumber *defined_Goal;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSNumber *total_Time;
@property (nullable, nonatomic, retain) NSSet<Times *> *times;

@end

@interface Goals (CoreDataGeneratedAccessors)

- (void)addTimesObject:(Times *)value;
- (void)removeTimesObject:(Times *)value;
- (void)addTimes:(NSSet<Times *> *)values;
- (void)removeTimes:(NSSet<Times *> *)values;

@end

NS_ASSUME_NONNULL_END
