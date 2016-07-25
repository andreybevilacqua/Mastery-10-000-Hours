//
//  KeyboardViewController.m
//  Mastery 10,000 Hours
//
//  Created by Andrey Bevilacqua on 7/24/16.
//  Copyright © 2016 Andrey Bevilacqua. All rights reserved.
//

#import "KeyboardViewController.h"

@interface KeyboardViewController ()

@end

@implementation KeyboardViewController

@synthesize textFieldTotalTime;

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
    
    textFieldTotalTime.keyboardType = UIKeyboardTypeDecimalPad;
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}


-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    /* for backspace */
    if([string length]==0){
        return YES;
    }
    
    /*  limit to only numeric characters  */
    
    NSCharacterSet *myCharSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    for (int i = 0; i < [string length]; i++) {
        unichar c = [string characterAtIndex:i];
        if ([myCharSet characterIsMember:c]) {
            return YES;
        }
    }
    
    return NO;
}

- (IBAction)buttonSave:(id)sender {
    
}

- (IBAction)buttonCancel:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"goalSaved" object:nil userInfo:nil];
        
    }];
}
@end
