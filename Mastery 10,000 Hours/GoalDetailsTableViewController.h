//
//  GoalDetailsTableViewController.h
//  Mastery 10,000 Hours
//
//  Created by Andrey Bevilacqua on 7/5/16.
//  Copyright © 2016 Andrey Bevilacqua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoalsDB.h"
#import "TimesDB.h"
#import "GoalsListTableViewController.h"

@interface GoalDetailsTableViewController : UITableViewController{
    
    GoalsDB *goalsDB;
    TimesDB *timesDB;
    GoalsListTableViewController *goalsListTableViewController;
}

@property (nonatomic, strong) NSString *selectedGoal;
@property (nonatomic, strong) NSMutableArray *arrayTimes;

- (IBAction)buttonEditTimeRegister:(id)sender;

- (NSString *)parseTimeString:(NSNumber *)time;

@end
