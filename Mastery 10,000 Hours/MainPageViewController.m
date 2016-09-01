//
//  MainPageViewController.m
//  Mastery 10,000 Hours
//
//  Created by Andrey Bevilacqua on 6/14/16.
//  Copyright © 2016 Andrey Bevilacqua. All rights reserved.
//
// [goalsDB deleteAllObjects:@"Goals"];

#import "MainPageViewController.h"
#import "AppDelegate.h"
#import "GoalsDB.h"
#import "TimesDB.h"

@interface MainPageViewController ()

@end

@implementation MainPageViewController

@synthesize buttonStartTime;
@synthesize labelSelectedGoal;
@synthesize labelStopwatch;
@synthesize labelInstruction;
@synthesize goalName;

/*
    O QUE FALTA:
        - Limitar a subida dos registros de tempo, pra que eles não fiquem em cima da header cell;
        - Criar icons para o app.
 */

#pragma mark - Beginning

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    seconds = 0;
    minutes = 0;
    hours = 0;
    totalStopWatchTimer = 0; // In Seconds!!!
    
    timerRegister = [NSNumber numberWithDouble:0];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedNotification_CreateGoalVC:) name:@"goalSaved" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedNotification_GoalsListTbVC:) name:@"zeroGoals" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedNotification_KeyboardVC:) name:@"keyboardAddTime" object:nil];
    
    goalsDB = [GoalsDB new];
    timesDB = [TimesDB new];
    
    labelSelectedGoal.text = [self setLabelSelectedGoalText];
    
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
}

#pragma mark - NSNotificationCenter

// Received Notification from CreateGoalViewController
- (void)receivedNotification_CreateGoalVC:(NSNotification *)note {
    
    if([[note name] isEqualToString:@"goalSaved"]){
        
        labelSelectedGoal.text = [self setLabelSelectedGoalText];
        
    }
}

// Received Notification from GoalsListTableViewController
- (void)receivedNotification_GoalsListTbVC:(NSNotification *)note {
    
    if([[note name] isEqualToString:@"zeroGoals"]){
        
        labelSelectedGoal.text = @"No goal created yet";
        
    }
}

// Received Notification from KeyboardViewController
- (void)receivedNotification_KeyboardVC:(NSNotification *)note {
    
    if([[note name] isEqualToString:@"keyboardAddTime"]){
        
        [self notificationsToTheUser:@"Great!!! Keep going!"];
    }
}

#pragma mark - View Edit

- (NSString *)setLabelSelectedGoalText{
    
    NSString *retorno = [goalsDB loadSelectedGoal];
    
    if ([retorno isEqualToString:@""]){
        
        retorno = @"No goal created yet";
    }
    
    return retorno;
}

#pragma mark - Stopwatch Action Buttons

- (IBAction)buttonStartTime:(id)sender {
    
    if([[labelSelectedGoal text] isEqualToString:@"No goal created yet"]){
        
        [self notificationsToTheUser:@"First of all, create a goal."];
        
    } else {
        
        if([buttonStartTime.currentTitle isEqualToString:@"Start!"]){
            
            [stopWatchTimer invalidate]; // Invalidate means 'stop the timer'. If you click 2x times, the first timer stop and a new one starts.
            stopWatchTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(stopWatch) userInfo:nil repeats:YES];
            
            [buttonStartTime setTitle:@"Stop!" forState:UIControlStateNormal];
            [labelInstruction setText:@"You can close the app"];
            
        } else {
            
            [NSTimer cancelPreviousPerformRequestsWithTarget:self selector:@selector(stopWatch) object:nil];
            
            [buttonStartTime setTitle:@"Start!" forState:UIControlStateNormal];
            [labelInstruction setText:@"Tap start button"];
        }
        
    }
    
}

- (IBAction)buttonSaveTime:(id)sender {
    
    if([timerRegister doubleValue] != 0){
        
        [NSTimer cancelPreviousPerformRequestsWithTarget:self selector:@selector(stopWatch) object:nil];
        
        if([timesDB saveNewTime:timerRegister]){
            
            [buttonStartTime setTitle:@"Start!" forState:UIControlStateNormal];
            
            [self notificationsToTheUser:@"GREAT!!! Keep going!"];
            [self buttonReset:self];
            
        } else {
            
            [self notificationsToTheUser:@"Error!"];
        }
        
    }
    
}

- (IBAction)buttonReset:(id)sender {
    
    [stopWatchTimer invalidate];
    
    seconds = 0;
    minutes = 0;
    hours = 0;
    totalStopWatchTimer = 0;
    
    timerRegister = [NSNumber numberWithDouble:0];
    
    [labelStopwatch setText:@"00:00:00"];
    [buttonStartTime setTitle:@"Start!" forState:UIControlStateNormal];
    [labelInstruction setText:@"You can close the app"];
    
}

- (void)stopWatch{
    
    if([buttonStartTime.currentTitle isEqualToString:@"Stop!"]){
        
        seconds = seconds + 1;
        
        if(seconds == 60){
            
            seconds = 0;
            minutes = minutes + 1;
            
            if(minutes == 60){
                
                minutes = 0;
                hours = hours + 1;
            }
        }
        
        if(seconds < 10){
            
            secondsString = [NSMutableString stringWithFormat:@"0%f", seconds];
            
        } else {
            
            secondsString = [NSMutableString stringWithFormat:@"%f", seconds];
        }
        
        if(minutes < 10){
            
            minutesString = [NSMutableString stringWithFormat:@"0%f", minutes];
            
        } else {
            
            minutesString = [NSMutableString stringWithFormat:@"%f", minutes];
        }
        
        if(hours < 10){
            
            hoursString = [NSMutableString stringWithFormat:@"0%f", hours];
            
        } else {
            
            hoursString = [NSMutableString stringWithFormat:@"%f", hours];
        }
        
        [secondsString replaceCharactersInRange:[secondsString rangeOfString:@".000000"] withString:@""];
        
        [minutesString replaceCharactersInRange:[minutesString rangeOfString:@".000000"] withString:@""];
        
        [hoursString replaceCharactersInRange:[hoursString rangeOfString:@".000000"] withString:@""];
        
        textStopwatch = [NSString stringWithFormat:@"%@:%@:%@", hoursString, minutesString, secondsString];
        
        [labelStopwatch setText:textStopwatch];

        // Total time is increasing every time;
        totalStopWatchTimer = 0; // This is necessary so that the routine does not add 2x the same time;
        totalStopWatchTimer = totalStopWatchTimer + seconds;
        totalStopWatchTimer = totalStopWatchTimer + (60 * minutes);
        totalStopWatchTimer = totalStopWatchTimer + ((60 * 60) * hours);
        
        timerRegister = [NSNumber numberWithDouble:totalStopWatchTimer];
        
    } else {
        
        totalTime = labelStopwatch.text;
        
    }
    
}

#pragma mark - Segues

- (IBAction)buttonCreateGoal:(id)sender {
    
    [self performSegueWithIdentifier:@"segueCreateGoal" sender:self];
}

- (IBAction)buttonPlusTime:(id)sender {
    
    [self performSegueWithIdentifier:@"segueKeyboard" sender:self];
}

#pragma mark - Notification Messages

- (void)notificationsToTheUser:(NSString *)newNotification{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:newNotification preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
    
}

@end
