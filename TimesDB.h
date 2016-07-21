//
//  TimesDB.h
//  Mastery 10,000 Hours
//
//  Created by Andrey Bevilacqua on 7/6/16.
//  Copyright © 2016 Andrey Bevilacqua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import "Times.h"
#import "GoalsDB.h"

@interface TimesDB : NSObject{
    
    AppDelegate *appDelegate;
    NSManagedObjectContext *context;
    
    GoalsDB *goalsDB;
    
}

@property (nonatomic, strong) NSMutableArray *arrayTimes, *arrayTimes_bkp, *arrayGoals, *arrayGoals_bkp;

- (id)init;

- (void)loadCoreData;

- (NSMutableArray *)loadAndReturnCoreData;

- (NSMutableArray *)loadAllTimesOfAGoal:(NSString *)goalName;

- (BOOL)saveNewTime:(NSNumber *)newTimeRegister;

- (BOOL)deleteObject:(NSDate *)insertion_DateRegister andTimeRegister:(NSNumber *)timeRegister andGoalName:(Goals *)goalObject;

- (BOOL)deleteAllTimeRegisterOfAGoal:(NSString *)goalName;

- (BOOL)deleteAllObjects;

@end
