//
//  KeyboardViewController.h
//  Mastery 10,000 Hours
//
//  Created by Andrey Bevilacqua on 7/24/16.
//  Copyright © 2016 Andrey Bevilacqua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VMaskTextField.h"
#import "TimesDB.h"
#import "GoalsDB.h"

@interface KeyboardViewController : UIViewController <UITextFieldDelegate> {
    
    double seconds;
    double minutes;
    double hours;
    double totalKeyboardTime;
    
    NSMutableString *secondsString;
    NSMutableString *minutesString;
    NSMutableString *hoursString;
    NSString *totalKeyboardTimeString;
    
    NSNumber *totalKeyboardTime_NSNumber;
    
    TimesDB *timesDB;
    GoalsDB *goalsDB;
}

@property (strong, nonatomic) IBOutlet UITextField *textFieldTotalTime;
@property (weak, nonatomic) IBOutlet VMaskTextField* maskTextField;
@property(nonatomic, strong) NSMutableArray *arrayGoals;

- (IBAction)buttonSave:(id)sender;
- (IBAction)buttonCancel:(id)sender;

- (BOOL)validateIfThereIsAnyMainGoal;
- (BOOL)validateTimeRegister;
- (void)notificationsToTheUser:(NSString *)newNotification;

@end
