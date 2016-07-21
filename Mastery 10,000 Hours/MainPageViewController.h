//
//  MainPageViewController.h
//  Mastery 10,000 Hours
//
//  Created by Andrey Bevilacqua on 6/14/16.
//  Copyright © 2016 Andrey Bevilacqua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoalsDB.h"
#import "TimesDB.h"

@interface MainPageViewController : UIViewController{
    
    GoalsDB *goalsDB;
    TimesDB *timesDB;
    
    double seconds;
    double minutes;
    double hours;
    double totalStopWatchTimer;
    
    NSMutableString *secondsString;
    NSMutableString *minutesString;
    NSMutableString *hoursString;
    NSString *textStopwatch;
    NSString *totalTime;
    
    NSTimer *stopWatchTimer;
    
    NSNumber *timerRegister;
    
}

@property (nonatomic, strong) IBOutlet UILabel *labelSelectedGoal;
@property (strong, nonatomic) IBOutlet UILabel *labelInstruction;
@property (strong, nonatomic) IBOutlet UILabel *labelStopwatch;
@property (strong, nonatomic) IBOutlet UIButton *buttonStartTime;


@property (nonatomic, strong) NSString *goalName;

- (void)notificationsToTheUser:(NSString *)newNotification;

- (void)stopWatch;

- (NSString *)setLabelSelectedGoalText;

- (IBAction)buttonSaveTime:(id)sender;

- (IBAction)buttonStartTime:(id)sender;

- (IBAction)buttonReset:(id)sender;

- (IBAction)buttonCreateGoal:(id)sender;

@end
