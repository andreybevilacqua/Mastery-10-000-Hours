//
//  GoalDB.m
//  Mastery 10,000 Hours
//
//  Created by Andrey Bevilacqua on 6/14/16.
//  Copyright © 2016 Andrey Bevilacqua. All rights reserved.
//

#import "GoalsDB.h"
#import "AppDelegate.h"
#import "Goals.h"
#import "TimesDB.h"

@implementation GoalsDB

#pragma mark - Beginning

@synthesize arrayGoals, arrayGoals_Bkp;

- (id)init{
    
    appDelegate = [[UIApplication sharedApplication] delegate];
    context = [appDelegate managedObjectContext];
    arrayGoals = [[NSMutableArray alloc] init];
    arrayGoals_Bkp = [[NSMutableArray alloc] init];
    
    return self;
    
}

#pragma mark - Database: load

- (void)loadCoreData{
    
    NSFetchRequest *fetchRequest = [NSFetchRequest new];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Goals" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    [arrayGoals removeAllObjects];
    [arrayGoals addObjectsFromArray:fetchedObjects];
    [arrayGoals_Bkp setArray:self.arrayGoals];
    
}

- (NSMutableArray *)loadAndReturnCoreData{
    
    NSFetchRequest *fetchRequest = [NSFetchRequest new];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Goals" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    [arrayGoals removeAllObjects];
    [arrayGoals addObjectsFromArray:fetchedObjects];
    [arrayGoals_Bkp setArray:self.arrayGoals];
    
    return arrayGoals;
    
}

- (NSString *)loadSelectedGoal{
    
    /*
     Passo a passo:
        - Verificar se ja foi executado o loadCoreData;
            - Se nao, executar ele.
        - Criar filtro para capturar a meta principal;
        - Executar o filtro no array de backup;
        - Ele tem que SEMPRE encontrar APENAS 1 REGISTRO;
        - Retornar esse registro.
     */
    
    [self loadCoreData];
    
    // Default process to reset the arrayGoals_Bkp.
    [arrayGoals_Bkp removeAllObjects];
    [arrayGoals_Bkp setArray:self.arrayGoals];
    
    NSPredicate *wherePredicate = [NSPredicate predicateWithFormat:@"SELF.defined_Goal == YES"];
    
    // Its always only one main goal.
    NSArray *filteredArray = [arrayGoals_Bkp filteredArrayUsingPredicate:wherePredicate];
    
    NSString *selectedGoal;
    
    if([filteredArray count] != 0 ){ // First load.
        
         selectedGoal = [[filteredArray objectAtIndex:0] name];
    } else{
        
        selectedGoal = @"";
    }
    
    return selectedGoal;
}

- (id)loadGoalObject:(NSString *)goalName{
    
    [self loadCoreData];
    
    // Default process to reset the arrayGoals_Bkp.
    [arrayGoals_Bkp removeAllObjects];
    [arrayGoals_Bkp setArray:self.arrayGoals];
    
    NSPredicate *wherePredicate = [NSPredicate predicateWithFormat:@"SELF.name == %@", goalName];
    
    // Its always only one main goal.
    NSArray *filteredArray = [arrayGoals_Bkp filteredArrayUsingPredicate:wherePredicate];
    
    if([filteredArray count] != 0 ){ // First load.
        
        return [filteredArray objectAtIndex:0];
    } else{
        
        return nil;
    }
    
}

- (id)loadSelectedObjectGoal{
    
    [self loadCoreData];
    
    // Default process to reset the arrayGoals_Bkp.
    [arrayGoals_Bkp removeAllObjects];
    [arrayGoals_Bkp setArray:self.arrayGoals];
    
    NSPredicate *wherePredicate = [NSPredicate predicateWithFormat:@"SELF.defined_Goal == YES"];
    
    // Its always only one main goal.
    NSArray *filteredArray = [arrayGoals_Bkp filteredArrayUsingPredicate:wherePredicate];
    
    if([filteredArray count] != 0 ){ // First load.
        
        return [filteredArray objectAtIndex:0];
    } else{
        
        return nil;
    }
    
}

#pragma mark - Database: update

- (BOOL)updateAllDefinedGoalsButNotOne:(NSString *)notThisGoal{
    
    NSNumber *definedGoal;
    
    [self loadCoreData];
    
    // Default process to reset the arrayGoals_Bkp.
    [arrayGoals_Bkp removeAllObjects];
    [arrayGoals_Bkp setArray:self.arrayGoals];
    
    NSPredicate *wherePredicate = [NSPredicate predicateWithFormat:@"SELF.name != %@", notThisGoal];
    
    NSArray *filteredArray = [arrayGoals_Bkp filteredArrayUsingPredicate:wherePredicate];
    
    for(int i = 0; i < [filteredArray count]; i++){
        
        if ([[[filteredArray objectAtIndex:i] defined_Goal] boolValue] == YES){
            
            definedGoal = [NSNumber numberWithBool:NO];
            [[filteredArray objectAtIndex:i] setDefined_Goal:definedGoal];
            
        };
    }
    
    NSError *error;
    [context save:&error];
    
    if(error){
        
        NSLog(@"Unresolved error %@, %@, %@", error, [error userInfo],[error localizedDescription]);
        return NO;
    }
    
    return YES;
}

- (BOOL)updateDefinedGoalOnSelectedGoal:(NSString *)goal{
    
    NSNumber *definedGoal;
    
    [self loadCoreData];
    
    // Default process to reset the arrayGoals_Bkp.
    [arrayGoals_Bkp removeAllObjects];
    [arrayGoals_Bkp setArray:self.arrayGoals];
    
    NSPredicate *wherePredicate = [NSPredicate predicateWithFormat:@"SELF.name == %@", goal];
    
    NSArray *filteredArray = [arrayGoals_Bkp filteredArrayUsingPredicate:wherePredicate];
    
    if ([[[filteredArray objectAtIndex:0] defined_Goal] boolValue] == NO){
        
        definedGoal = [NSNumber numberWithBool:YES];
        
    }
    
    [[filteredArray objectAtIndex:0] setDefined_Goal:definedGoal];
    
    NSError *error;
    [context save:&error];
    
    if(error){
        
        NSLog(@"Unresolved error %@, %@, %@", error, [error userInfo],[error localizedDescription]);
        return NO;
    }
    
    return YES;
}

- (BOOL)updateTotalTime:(NSString *)goal andTotalTime:(NSNumber *)totalTime andSumOrSubtraction:(NSString *)sumOrSubtraction{
    
    [self loadCoreData];
    
    // Default process to reset the arrayGoals_Bkp.
    [arrayGoals_Bkp removeAllObjects];
    [arrayGoals_Bkp setArray:self.arrayGoals];
    
    NSPredicate *wherePredicate = [NSPredicate predicateWithFormat:@"SELF.name == %@", goal];
    
    NSArray *filteredArray = [arrayGoals_Bkp filteredArrayUsingPredicate:wherePredicate];
    
    double newTotalTime = 0;
    
    if([[sumOrSubtraction uppercaseString] isEqualToString:@"SUM"]){
        
        // Sum the registered time with new time;
        newTotalTime = ([[[filteredArray objectAtIndex:0] total_Time] doubleValue]) + ([totalTime doubleValue]);
        
    } else if([[sumOrSubtraction uppercaseString] isEqualToString:@"SUBTRACTION"]){

        // Subtraction the registered time with new time;
        newTotalTime = ([[[filteredArray objectAtIndex:0] total_Time] doubleValue]) - ([totalTime doubleValue]);
        
    }
    
    [[filteredArray objectAtIndex:0] setTotal_Time:[NSNumber numberWithDouble:newTotalTime]];
    
    NSError *error;
    [context save:&error];
    
    if(error){
        
        NSLog(@"Unresolved error %@, %@, %@", error, [error userInfo],[error localizedDescription]);
        return NO;
    }
    
    return YES;
}

- (BOOL)updateTotalTimeToZero:(NSString *)goal{
    
    [self loadCoreData];
    
    // Default process to reset the arrayGoals_Bkp.
    [arrayGoals_Bkp removeAllObjects];
    [arrayGoals_Bkp setArray:self.arrayGoals];
    
    NSPredicate *wherePredicate = [NSPredicate predicateWithFormat:@"SELF.name == %@", goal];
    
    NSArray *filteredArray = [arrayGoals_Bkp filteredArrayUsingPredicate:wherePredicate];
    
    [[filteredArray objectAtIndex:0] setTotal_Time:[NSNumber numberWithDouble:0]];
    
    NSError *error;
    [context save:&error];
    
    if(error){
        
        NSLog(@"Unresolved error %@, %@, %@", error, [error userInfo],[error localizedDescription]);
        return NO;
    }
    //NSLog(@"Objeto zerado");
    return YES;
}

#pragma mark - Database: save

- (BOOL)saveNewGoal:(NSString *)newGoalName{
    
    Goals *newGoal = [NSEntityDescription insertNewObjectForEntityForName:@"Goals" inManagedObjectContext:context];
    
    NSDate *currDate = [NSDate date];
    NSNumber *zero = [NSNumber numberWithInt:0];
    NSNumber *definedGoal = [NSNumber numberWithBool:YES];
    
    [newGoal setName:newGoalName];
    [newGoal setTotal_Time:zero];
    [newGoal setDefined_Goal:definedGoal];
    [newGoal setCreation_Date:currDate];
    
    NSError *error;
    [context save:&error];
    
    if(error){
        
        NSLog(@"Unresolved error %@, %@, %@", error, [error userInfo],[error localizedDescription]);
        return NO;
        
    } else{
        
        // Atualizar todas as outras metas para NO e deixar apenas a nova meta para YES!!!!
        [self updateAllDefinedGoalsButNotOne:newGoalName];
    }
    
    return YES;
}

#pragma mark - Database: Delete

- (BOOL)deleteObject:(NSString *)goal{

    TimesDB *timesDB = [TimesDB new];
    
    if([timesDB deleteAllTimeRegisterOfAGoal:goal]){
        
        [self loadCoreData];
        
        // Default process to reset the arrayGoals_Bkp.
        [arrayGoals_Bkp removeAllObjects];
        [arrayGoals_Bkp setArray:self.arrayGoals];
        
        NSPredicate *wherePredicate = [NSPredicate predicateWithFormat:@"SELF.name == %@", goal];
        
        NSArray *filteredArray = [arrayGoals_Bkp filteredArrayUsingPredicate:wherePredicate];
        
        NSError *error;
        
        [context deleteObject:[filteredArray objectAtIndex:0]];
        
        [context save:&error];
        
        if(error){
            
            NSLog(@"Unresolved error %@, %@, %@", error, [error userInfo],[error localizedDescription]);
            return NO;
            
        }
        
        return YES;
        
    } else{
        
        return NO;
    }
    
}

- (BOOL)deleteAllObjects{
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Goals" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    for(NSManagedObject *managedObject in fetchedObjects){
        
        [context deleteObject:managedObject];
        NSLog(@"object deleted");
    }
    
    if( ![context save:&error]){
        
        NSLog(@"Error deleting - error: %@", error);
        return NO;
    }
    
    return YES;
}

#pragma mark - Database: validations

- (BOOL)goalAlreadyExist:(NSString *)newGoalName{
    
    [self loadCoreData];
    
    for(int i = 0; i < [arrayGoals count]; i++){
        
        if( [[[[arrayGoals objectAtIndex:i] name] uppercaseString] isEqualToString:[newGoalName uppercaseString]]){
            
            return YES;
        }
    }
    
    return NO;
}

@end
