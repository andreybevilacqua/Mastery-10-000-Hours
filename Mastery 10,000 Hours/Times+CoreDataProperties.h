//
//  Times+CoreDataProperties.h
//  Mastery 10,000 Hours
//
//  Created by Andrey Bevilacqua on 7/6/16.
//  Copyright © 2016 Andrey Bevilacqua. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Times.h"

NS_ASSUME_NONNULL_BEGIN

@interface Times (CoreDataProperties)

@property (nullable, nonatomic, retain) NSDate *insertion_Date;
@property (nullable, nonatomic, retain) NSNumber *time;
@property (nullable, nonatomic, retain) Goals *goals;

@end

NS_ASSUME_NONNULL_END
