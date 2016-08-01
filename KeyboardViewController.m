//
//  KeyboardViewController.m
//  Mastery 10,000 Hours
//
//  Created by Andrey Bevilacqua on 7/24/16.
//  Copyright © 2016 Andrey Bevilacqua. All rights reserved.
//

#import "KeyboardViewController.h"
#import "VMaskTextField.h"

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
    
    secondsString = [NSMutableString stringWithFormat:@""];
    minutesString = [NSMutableString stringWithFormat:@""];
    hoursString = [NSMutableString stringWithFormat:@""];
    totalKeyboardTimeString = @"";
    
    maskTextField.mask = @"##:##:##";
    maskTextField.delegate = self;
    
    textFieldTotalTime.keyboardType = UIKeyboardTypeNumberPad;
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
    
    // CONTINUAR DAQUI!!!
    // 1 - Quebrar a string, separando horas, minutos e segundos. Add esses valores nas variaveis;
    // 2 - Valida se: segundos > 59 ? Notification User, blz; Minutos > 59 ? Notification User, blz.
    // 3 - Se passou em tudo, executa o bloco de código abaixo e salva no banco. 
    
    int seconds = 0;
    int minutes = 0;
    int hours = 0;
    double doubleTotalTime = 0;
    
    [self validateTimeRegister:maskTextField.text];
    
    /*
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
     
     
     
     
     if([timesDB saveNewTime:timerRegister]){
     
     [buttonStartTime setTitle:@"Start!" forState:UIControlStateNormal];
     
     [self notificationsToTheUser:@"GREAT!!! Keep going!"];
     [self buttonReset:self];
     
     } else {
     
     [self notificationsToTheUser:@"Error!"];
     }
     
     
     
     */
}

- (IBAction)buttonCancel:(id)sender {
    
    [textFieldTotalTime resignFirstResponder];
    
    [self dismissViewControllerAnimated:YES completion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"goalSaved" object:nil userInfo:nil];
        
    }];
}

// Doesnt matter what is the cause of the 'NO return', it always gonna blank the text field and wait for a valid information.
- (BOOL)validateTimeRegister:(NSNumber *)timeRegister{
    
    /*NSRange match = [newGoalName rangeOfString:@"["];
    NSRange match2 = [newGoalName rangeOfString:@"("];
    
    if(match.location == NSNotFound && match2.location == NSNotFound){
        
        return YES;
    } else{
        
        return NO;
    }*/
    
    return YES;
}

#pragma mark - Notification Messages

- (void)notificationsToTheUser:(NSString *)newNotification{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:newNotification preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
    
}

@end
