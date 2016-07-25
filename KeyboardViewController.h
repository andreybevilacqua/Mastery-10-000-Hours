//
//  KeyboardViewController.h
//  Mastery 10,000 Hours
//
//  Created by Andrey Bevilacqua on 7/24/16.
//  Copyright © 2016 Andrey Bevilacqua. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KeyboardViewController : UIViewController <UITextFieldDelegate> {
    
    double seconds;
    double minutes;
    double hours;
    double totalKeyboardTime;
    
    NSMutableString *secondsString;
    NSMutableString *minutesString;
    NSMutableString *hoursString;
    NSString *totalKeyboardTimeString;
}

@property (strong, nonatomic) IBOutlet UITextField *textFieldTotalTime;

- (IBAction)buttonSave:(id)sender;
- (IBAction)buttonCancel:(id)sender;


@end
