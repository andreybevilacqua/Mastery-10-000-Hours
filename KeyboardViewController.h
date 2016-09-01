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
}

@property (strong, nonatomic) IBOutlet UITextField *textFieldTotalTime;
@property (weak, nonatomic) IBOutlet VMaskTextField* maskTextField;

- (IBAction)buttonSave:(id)sender;
- (IBAction)buttonCancel:(id)sender;

- (BOOL)validateTimeRegister;
- (void)notificationsToTheUser:(NSString *)newNotification;

@end
