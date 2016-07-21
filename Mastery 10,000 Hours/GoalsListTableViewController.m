//
//  GoalsListTableViewController.m
//  Mastery 10,000 Hours
//
//  Created by Andrey Bevilacqua on 6/27/16.
//  Copyright © 2016 Andrey Bevilacqua. All rights reserved.
//

#import "GoalsListTableViewController.h"
#import "cellGoalsProgressTableViewCell.h"
#import "GoalsDB.h"
#import "TimesDB.h"
#import "Goals.h"
#import "GoalDetailsTableViewController.h"

@interface GoalsListTableViewController ()

@end

@implementation GoalsListTableViewController

@synthesize arrayGoals;
@synthesize arrayTimes;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    goalsDB = [GoalsDB new];
    timesDB = [TimesDB new];
    
    arrayGoals = [NSMutableArray new];
    arrayTimes = [NSMutableArray new];
    
    arrayGoals = [goalsDB loadAndReturnCoreData];
    arrayTimes = [timesDB loadAndReturnCoreData];
    
}

- (void)viewWillAppear:(BOOL)animated{ // Delegate to atualize tableview every time that user select
    
    arrayGoals = [goalsDB loadAndReturnCoreData];
    arrayTimes = [timesDB loadAndReturnCoreData];
    
    [self.tableView reloadData];
    
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
}

#pragma mark - Table cells

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    cellGoalsProgressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"identifierCellGoalsProgress" forIndexPath:indexPath];
    
    Goals *goals = [arrayGoals objectAtIndex:indexPath.row];
    
    [cell.labelGoalsName setText:goals.name];
    [cell.labelTotalTime setText:[self totalTimeString:[goals total_Time]]];
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    
    Goals *goals = [arrayGoals objectAtIndex:indexPath.row];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *setMainGoalButton = [UIAlertAction actionWithTitle:@"Set as Main Goal"
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * _Nonnull action) {
                                                            
                                                            if([[goals defined_Goal] isEqualToNumber:[NSNumber numberWithInteger:0]]){
                                                                
                                                                [goalsDB updateDefinedGoalOnSelectedGoal:[[arrayGoals objectAtIndex:indexPath.row] name]];
                                                                [goalsDB updateAllDefinedGoalsButNotOne:[[arrayGoals objectAtIndex:indexPath.row] name]];
                                                                
                                                                
                                                                [self notificationsToTheUser:
                                                                 [NSString stringWithFormat:@"%@ is now the main goal!",
                                                                  [[arrayGoals objectAtIndex:indexPath.row] name]]];
                                                                
                                                                [[NSNotificationCenter defaultCenter] postNotificationName:@"goalSaved" object:nil userInfo:nil];
                                                                
                                                            } else {
                                                                [self notificationsToTheUser:
                                                                 [NSString stringWithFormat:@"This is the main goal."]];
                                                            }
                                                            
                                                        }];
    
    UIAlertAction *cancelButton = [UIAlertAction actionWithTitle:@"Cancel"
                                                          style:UIAlertActionStyleCancel
                                                        handler:nil
                                                        ];
    
    [alertController addAction:setMainGoalButton];
    [alertController addAction:cancelButton];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete){
        
        NSString *deletedGoal = [[arrayGoals objectAtIndex:indexPath.row] name];
        NSString *lastGoal = [[arrayGoals objectAtIndex:[arrayGoals count] - 1 ] name];
        
        if([goalsDB deleteObject:[[arrayGoals objectAtIndex:indexPath.row] name]]){
            
            [arrayGoals removeObjectAtIndex:indexPath.row];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            
            // If the deleted goal was the main goal.
            if([deletedGoal isEqualToString:lastGoal]){
                
                // And If the deleted goal was not the last goal
                if([arrayGoals count] > 0){
                    
                    [goalsDB updateDefinedGoalOnSelectedGoal:[[arrayGoals objectAtIndex:[arrayGoals count] - 1] name]];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"goalSaved" object:nil userInfo:nil];
                }
                
            }
            
        } else {
            
            [self notificationsToTheUser:@"Error at deleting register!"];
            
        }
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert){
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if([arrayGoals count] > 0){
        
        return [arrayGoals count];
        
    } else {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"zeroGoals" object:nil userInfo:nil];
        
        return 0;
    }
    
}

#pragma mark - Total Time string format:

- (NSString *)totalTimeString:(NSNumber *)totalTime{
    
    NSString *totalTimeString = [NSString stringWithFormat:@"00:00:00"];
    
    int seconds = 0;
    int minutes = 0;
    int hours = 0;
    double doubleTotalTime = [totalTime doubleValue];
    
    NSString *secondsString = @"";
    NSString *minutesString = @"";
    NSString *hoursString = @"";
    
    seconds = (fmod(doubleTotalTime, 60));
    doubleTotalTime /= 60;
    minutes = (fmod(doubleTotalTime, 60));
    doubleTotalTime /= 60;
    hours = ((int)doubleTotalTime);
    
    /*seconds = (intTotalTime % 60);
    intTotalTime /= 60;
    minutes = (intTotalTime % 60);
    intTotalTime /= 60;
    hours = (intTotalTime % 24);*/
    
    if(seconds < 10){
        
        secondsString = [NSString stringWithFormat:@"0%d", seconds];
        
    } else {
        
        secondsString = [NSString stringWithFormat:@"%d", seconds];
    }
    
    if(minutes < 10){
        
        minutesString = [NSString stringWithFormat:@"0%d", minutes];
        
    } else {
        
        minutesString = [NSString stringWithFormat:@"%d", minutes];
    }
    
    if(hours < 10){
        
        hoursString = [NSString stringWithFormat:@"0%d", hours];
        
    } else {
        
        hoursString = [NSString stringWithFormat:@"%d", hours];
    }
    
    totalTimeString = [NSString stringWithFormat:@"%@:%@:%@", hoursString, minutesString, secondsString];
    
    return totalTimeString;
}

#pragma mark - Buttons

- (IBAction)buttonEditGoalsList:(id)sender {
    
}

#pragma mark - Segues

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self performSegueWithIdentifier:@"segueGoalDetails" sender:self];
    
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if([[segue identifier] isEqualToString:@"segueGoalDetails"]){
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        NSString *selectedGoal = [[arrayGoals objectAtIndex:indexPath.row] name];
        
        GoalDetailsTableViewController *g = [segue destinationViewController];
        [g setSelectedGoal:selectedGoal];
        
    }
    
}

#pragma mark - Notification Messages

- (void)notificationsToTheUser:(NSString *)newNotification{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:newNotification preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
    
}

@end
