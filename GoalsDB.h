//
//  GoalDB.h
//  Mastery 10,000 Hours
//
//  Created by Andrey Bevilacqua on 6/14/16.
//  Copyright © 2016 Andrey Bevilacqua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

@interface GoalsDB : NSObject {
    
    AppDelegate *appDelegate;
    NSManagedObjectContext *context;
}

@property(nonatomic, strong) NSMutableArray *arrayGoals, *arrayGoals_Bkp;

- (id)init;

- (void)loadCoreData;

- (NSMutableArray *)loadAndReturnCoreData;

- (NSString *)loadSelectedGoal;

- (id)loadSelectedObjectGoal;

- (id)loadGoalObject:(NSString *)goalName;

- (BOOL)saveNewGoal:(NSString *)newGoalName;

- (BOOL)updateDefinedGoalOnSelectedGoal:(NSString *)goal;

- (BOOL)updateAllDefinedGoalsButNotOne:(NSString *)notThisGoal;

- (BOOL)updateTotalTime:(NSString *)goal andTotalTime:(NSNumber *)totalTime andSumOrSubtraction:(NSString *)sumOrSubtraction;

- (BOOL)updateTotalTimeToZero:(NSString *)goal;

- (BOOL)deleteObject:(NSString *)goal;

- (BOOL)deleteAllObjects;

- (BOOL)goalAlreadyExist:(NSString *)newGoalName;

@end
