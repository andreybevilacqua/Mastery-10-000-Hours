//
//  GoalDetailsTableViewController.m
//  Mastery 10,000 Hours
//
//  Created by Andrey Bevilacqua on 7/5/16.
//  Copyright © 2016 Andrey Bevilacqua. All rights reserved.
//

#import "GoalDetailsTableViewController.h"
#import "cellGoalNameTableViewCell.h"
#import "cellGoalTimeRegisterTableViewCell.h"
#import "GoalsDB.h"
#import "TimesDB.h"
#import "Goals.h"
#import "Times.h"
#import "GoalsListTableViewController.h"

@interface GoalDetailsTableViewController ()

@end

@implementation GoalDetailsTableViewController

@synthesize selectedGoal;
@synthesize arrayTimes;

- (void)viewDidLoad {

    [super viewDidLoad];
    
    goalsDB = [GoalsDB new];
    timesDB = [TimesDB new];
    goalsListTableViewController = [GoalsListTableViewController new];
    
    arrayTimes = [NSMutableArray new];

}

- (void)viewWillAppear:(BOOL)animated{
    
    arrayTimes = [timesDB loadAllTimesOfAGoal:[goalsDB loadGoalObject:selectedGoal]];
    
    // Sorting arrayTimes:
    NSSortDescriptor *sd = [[NSSortDescriptor alloc] initWithKey:@"insertion_Date" ascending:NO];
    NSArray *arrayTimes_bkp = [arrayTimes sortedArrayUsingDescriptors:[NSArray arrayWithObjects:sd, nil]];
    
    // Transform an NSArray into a NSMutableArray.
    arrayTimes = [NSMutableArray arrayWithArray:arrayTimes_bkp];
    
    [self.tableView reloadData];
    
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
}

#pragma mark - Table cells

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    cellGoalTimeRegisterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"identifierCellGoalTimeRegister" forIndexPath:indexPath];
    
    Times *times = [arrayTimes objectAtIndex:indexPath.row];
    
    NSMutableString *insertionDateString = [NSMutableString stringWithFormat:@"%@", [times insertion_Date]];
    NSString *timeString = [self parseTimeString:[times time]];
    
    [insertionDateString replaceCharactersInRange:[insertionDateString rangeOfString:@"+0000"] withString:@""];
    
    [cell.labelTimeRegister_CreationDate setText:[NSString stringWithFormat:@"%@ -> %@", insertionDateString, timeString]];
    
    return cell;
    
}

// Corrigir primeira celula para ela nao ser puxada junto!!!
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete){
        
        if([timesDB deleteObject:[[arrayTimes objectAtIndex:indexPath.row] insertion_Date]
                    andTimeRegister:[[arrayTimes objectAtIndex:indexPath.row] time]
                    andGoalName:[[arrayTimes objectAtIndex:indexPath.row] goals]]) {
            
            [arrayTimes removeObjectAtIndex:indexPath.row];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            
        } else {
            
            [self notificationsToTheUser:@"Error at deleting register!"];
            
        }
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert){
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
    
    [self.tableView reloadData];
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if([arrayTimes count] > 0){
        
        return [arrayTimes count];
        
    } else {
        
        return 0;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 140.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60.0;
}

#pragma mark - Header Cell

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    Goals *goal = [goalsDB loadGoalObject:selectedGoal];
    
    cellGoalNameTableViewCell *headerCell = [tableView dequeueReusableCellWithIdentifier:@"identifierCellGoalName"];
    [headerCell setEditing:NO];
    
    NSString *stringTotalTime = [NSString stringWithFormat:@"%@ Total Hours", [goalsListTableViewController totalTimeString:[goal total_Time]]];
    
    [headerCell.labelGoalName setText:[goal name]];
    [headerCell.labelTotalTime setText:[NSString stringWithFormat:@"%@",stringTotalTime]];
    
    // This solve the header move.
    // You can do the same with the footer cell.
    return headerCell.contentView;
    
}

#pragma mark - Buttons

- (IBAction)buttonEditTimeRegister:(id)sender {
    
}

#pragma mark - Notification Messages

- (void)notificationsToTheUser:(NSString *)newNotification{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:newNotification preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
    
}

#pragma mark - Time string:

- (NSString *)parseTimeString:(NSNumber *)time{
    
    NSString *timeString = [NSString stringWithFormat:@"00:00:00"];
    
    int seconds = 0;
    int minutes = 0;
    int hours = 0;
    double doubleTotalTime = [time doubleValue];
    
    NSString *secondsString = @"";
    NSString *minutesString = @"";
    NSString *hoursString = @"";
    
    seconds = (fmod(doubleTotalTime,60));
    doubleTotalTime /= 60;
    minutes = (fmod(doubleTotalTime, 60));
    doubleTotalTime /= 60;
    hours = ((int)doubleTotalTime);
    
    if(seconds < 10){
        
        secondsString = [NSString stringWithFormat:@"0%i", seconds];
        
    } else {
        
        secondsString = [NSString stringWithFormat:@"%i", seconds];
    }
    
    if(minutes < 10){
        
        minutesString = [NSString stringWithFormat:@"0%i", minutes];
        
    } else {
        
        minutesString = [NSString stringWithFormat:@"%i", minutes];
    }
    
    if(hours < 10){
        
        hoursString = [NSString stringWithFormat:@"0%i", hours];
        
    } else {
        
        hoursString = [NSString stringWithFormat:@"%i", hours];
    }
    
    timeString = [NSString stringWithFormat:@"%@:%@:%@", hoursString, minutesString, secondsString];
    
    return timeString;
}


@end
