//
//  KeyboardViewController.m
//  Mastery 10,000 Hours
//
//  Created by Andrey Bevilacqua on 7/24/16.
//  Copyright © 2016 Andrey Bevilacqua. All rights reserved.
//

#import "KeyboardViewController.h"
#import "VMaskTextField.h"
#import "TimesDB.h"

@interface KeyboardViewController ()

@end

@implementation KeyboardViewController

@synthesize textFieldTotalTime;
@synthesize maskTextField;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    seconds = 0;
    minutes = 0;
    hours = 0;
    totalKeyboardTime = 0;
    totalKeyboardTime_NSNumber = [NSNumber numberWithDouble:0];
    
    secondsString = [NSMutableString stringWithFormat:@""];
    minutesString = [NSMutableString stringWithFormat:@""];
    hoursString = [NSMutableString stringWithFormat:@""];
    totalKeyboardTimeString = @"";
    
    maskTextField.mask = @"##:##:##";
    maskTextField.delegate = self;
    
    textFieldTotalTime.keyboardType = UIKeyboardTypeNumberPad;
    
    timesDB = [TimesDB new];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

// Every time you touch in the screen, keyboard is dismissed.
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    return  [maskTextField shouldChangeCharactersInRange:range replacementString:string];
}

- (IBAction)buttonSave:(id)sender {
    
    if([self validateTimeRegister]){
        
        // Increasing total time;
        totalKeyboardTime = 0; // This is necessary so that the routine does not add 2x the same time;
        totalKeyboardTime = totalKeyboardTime + seconds;
        totalKeyboardTime = totalKeyboardTime + (60 * minutes);
        totalKeyboardTime = totalKeyboardTime + ((60 * 60) * hours);
        
        totalKeyboardTime_NSNumber = [NSNumber numberWithDouble:totalKeyboardTime];
        
        if([timesDB saveNewTime:totalKeyboardTime_NSNumber]){
            [self dismissViewControllerAnimated:YES completion:^{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"keyboardAddTime" object:nil userInfo:nil];
                
            }];
        } else{
            [self notificationsToTheUser:@"Error!"];
        }
    }
}

#pragma mark - Input validation

// Doesnt matter what is the cause of the 'NO return', it always gonna blank the text field and wait for a valid information.
- (BOOL)validateTimeRegister{
    
    if(maskTextField.text.length < 8){
        
        [self notificationsToTheUser:@"Please complete all field."];
        return NO;
    } else{
        
        BOOL alreadyNotified = NO;
        
        seconds = [[maskTextField.text substringWithRange:NSMakeRange(6, 2)] intValue];
        minutes = [[maskTextField.text substringWithRange:NSMakeRange(3, 2)] intValue];
        hours = [[maskTextField.text substringWithRange:NSMakeRange(0, 2)] intValue];
        
        if(seconds > 59){
            
            [self notificationsToTheUser:@"Seconds must be between 00 and 59"];
            alreadyNotified = YES;
            
        } else if(minutes > 59 && !alreadyNotified){
            
            [self notificationsToTheUser:@"Minutes must be between 00 and 59"];
            alreadyNotified = YES;
        }
        
        if(alreadyNotified){
            return NO;
        }
    }
    
    return YES;
}

- (IBAction)buttonCancel:(id)sender {
    
    [textFieldTotalTime resignFirstResponder];
    
    [self dismissViewControllerAnimated:YES completion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"goalSaved" object:nil userInfo:nil];
        
    }];
}

#pragma mark - Notification Messages

- (void)notificationsToTheUser:(NSString *)newNotification{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:newNotification preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
