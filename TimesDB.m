//
//  TimesDB.m
//  Mastery 10,000 Hours
//
//  Created by Andrey Bevilacqua on 7/6/16.
//  Copyright © 2016 Andrey Bevilacqua. All rights reserved.
//

#import "TimesDB.h"
#import "AppDelegate.h"
#import "Times.h"
#import "GoalsDB.h"
#import "Goals.h"

@implementation TimesDB

@synthesize arrayTimes, arrayGoals;
@synthesize arrayTimes_bkp, arrayGoals_bkp;


- (id)init{
    
    appDelegate = [[UIApplication sharedApplication] delegate];
    context = [appDelegate managedObjectContext];
    arrayTimes = [NSMutableArray new];
    arrayGoals = [NSMutableArray new];
    arrayTimes_bkp = [NSMutableArray new];
    arrayGoals_bkp = [NSMutableArray new];
    
    goalsDB = [GoalsDB new];
    
    return self;
    
}

#pragma mark - Database: Load

- (void)loadCoreData{
    
    NSFetchRequest *fetchRequest = [NSFetchRequest new];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Times" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    NSArray *fetchObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    [arrayTimes removeAllObjects];
    [arrayTimes addObjectsFromArray:fetchObjects];
    [arrayTimes_bkp setArray:arrayTimes];
    
}

- (NSMutableArray *)loadAndReturnCoreData{
    
    NSFetchRequest *fetchRequest = [NSFetchRequest new];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Times" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    NSArray *fetchObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    [arrayTimes removeAllObjects];
    [arrayTimes addObjectsFromArray:fetchObjects];
    [arrayTimes_bkp setArray:arrayTimes];
    
    return arrayTimes;
}

- (NSArray *)loadAllTimesOfAGoal:(Goals *)goal{
    
    [self loadCoreData];
    
    // Default process to reset the arrayGoals_Bkp.
    [arrayTimes_bkp removeAllObjects];
    [arrayTimes_bkp setArray:self.arrayTimes];
    
    NSPredicate *wherePredicate = [NSPredicate predicateWithFormat:@"SELF.goals == %@", goal];
    
    // Its always only one main goal.
    NSArray *filteredArray = [arrayTimes_bkp filteredArrayUsingPredicate:wherePredicate];
    
    if([filteredArray count] != 0 ){ 
        
        // Transform an NSArray into a NSMutableArray.
        NSMutableArray *mutableFilteredArray = [NSMutableArray new];
        mutableFilteredArray = [NSMutableArray arrayWithArray:filteredArray];
        
        return mutableFilteredArray;
    } else{
        
        return nil;
    }
    
}


#pragma mark - Database: Save

- (BOOL)saveNewTime:(NSNumber *)newTimeRegister{
    
    Goals *goal = [goalsDB loadSelectedObjectGoal];
    
    Times *newTime = [NSEntityDescription insertNewObjectForEntityForName:@"Times" inManagedObjectContext:context];
    
    NSDate *currDate = [NSDate date];
    
    [newTime setInsertion_Date:currDate];
    [newTime setTime:newTimeRegister];
    [newTime setGoals:goal];
    
    NSError *error;
    [context save:&error];
    
    if(error){
        
        NSLog(@"Unresolved error %@, %@, %@", error, [error userInfo],[error localizedDescription]);
        
    } else {
        
        if([goalsDB updateTotalTime:[goal name] andTotalTime:newTimeRegister andSumOrSubtraction:@"SUM"]){
            
            return YES;
        }
        
    }
    
    return NO;
    
}

#pragma mark - Database: Delete

- (BOOL)deleteObject:(NSDate *)insertion_DateRegister andTimeRegister:(NSNumber *)timeRegister andGoalName:(Goals *)goalObject{
    
    [self loadCoreData];
    
    Goals *goal = [goalsDB loadGoalObject:[goalObject name]]; // Delete from the correct goal.
    
    // Default process to reset the arrayGoals_Bkp.
    [arrayTimes_bkp removeAllObjects];
    [arrayTimes_bkp setArray:self.arrayTimes];
    
    NSPredicate *wherePredicate = [NSPredicate predicateWithFormat:@"SELF.insertion_Date == %@ AND SELF.goals == %@", insertion_DateRegister, goal];
    
    NSArray *filteredArray = [arrayTimes_bkp filteredArrayUsingPredicate:wherePredicate];
    
    NSError *error;
    
    [context deleteObject:[filteredArray objectAtIndex:0]];
    
    [context save:&error];
    
    if(error){
        
        NSLog(@"Unresolved error %@, %@, %@", error, [error userInfo],[error localizedDescription]);
        
    } else {
        
        if([goalsDB updateTotalTime:[goal name] andTotalTime:timeRegister andSumOrSubtraction:@"SUBTRACTION"]){
            
            return YES;
        }
        
    }
    
    return NO;
}

- (BOOL)deleteAllTimeRegisterOfAGoal:(Goals *)goal;{
    
    [self loadCoreData];
    
    //Goals *goalObject = [goalsDB loadSelectedObjectGoal];
    
    // Default process to reset the arrayGoals_Bkp.
    [arrayTimes_bkp removeAllObjects];
    [arrayTimes_bkp setArray:self.arrayTimes];

    NSPredicate *wherePredicate = [NSPredicate predicateWithFormat:@"SELF.goals == %@", goal];
    
    NSArray *filteredArray = [arrayTimes_bkp filteredArrayUsingPredicate:wherePredicate];
    
    NSError *error;
    
    for(NSManagedObject *managedObject in filteredArray){
        
        [context deleteObject:managedObject];
        //NSLog(@"object deleted");
    }
    
    if( ![context save:&error]){
        
        NSLog(@"Error deleting - error: %@", error);
        return NO;
    }
    
    return YES;
}


- (BOOL)deleteAllObjects{
    
    NSFetchRequest *fetchRequest = [NSFetchRequest new];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Times" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    NSArray *fetchObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    for(NSManagedObject *managedObject in fetchObjects){
        
        [context deleteObject:managedObject];
        NSLog(@"object deleted");
    }
    
    if( ![context save:&error]){
        
        NSLog(@"Error deleting - error: %@", error);
        return NO;
    }
    
    return YES;
}

@end
