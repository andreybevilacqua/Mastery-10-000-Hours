//
//  GoalsListTableViewController.h
//  Mastery 10,000 Hours
//
//  Created by Andrey Bevilacqua on 6/27/16.
//  Copyright © 2016 Andrey Bevilacqua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoalsDB.h"
#import "TimesDB.h"

@interface GoalsListTableViewController : UITableViewController{
    
    GoalsDB *goalsDB;
    TimesDB *timesDB;
}

@property (nonatomic, strong) NSMutableArray *arrayGoals;
@property (nonatomic, strong) NSMutableArray *arrayTimes;

- (IBAction)buttonEditGoalsList:(id)sender;

- (void)notificationsToTheUser:(NSString *)newNotification;

- (NSString *)totalTimeString:(NSNumber *)totalTime;

@end
