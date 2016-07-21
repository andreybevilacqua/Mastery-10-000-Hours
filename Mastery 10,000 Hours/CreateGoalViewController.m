//
//  CreateGoalViewController.m
//  Mastery 10,000 Hours
//
//  Created by Andrey Bevilacqua on 6/25/16.
//  Copyright © 2016 Andrey Bevilacqua. All rights reserved.
//

#import "CreateGoalViewController.h"
#import "GoalsDB.h"

@interface CreateGoalViewController ()

@end

@implementation CreateGoalViewController

@synthesize textFieldGoalName;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    goalsDB = [GoalsDB new];
    
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
}

#pragma mark - Action Buttons 

- (IBAction)buttonSaveGoal:(id)sender {
    
    if([textFieldGoalName.text length ] > 0){
        
        if([self validateGoalName:textFieldGoalName.text]){
            
            NSString *goalName = textFieldGoalName.text;
            
            if(![goalsDB goalAlreadyExist:goalName]){
                
                if([goalsDB saveNewGoal:goalName]){
                    
                    [self dismissViewControllerAnimated:YES completion:^{
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"goalSaved" object:nil userInfo:nil];
                        
                    }];
                    
                }
                
            } else{
                
                [self notificationsToTheUser:@"Goal Name already exists! Try a new name"];
                textFieldGoalName.text = @"";
            }
            
        } else{
            
            textFieldGoalName.text = @"";
        }
        
    }
}

- (IBAction)buttonCancelGoal:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"goalSaved" object:nil userInfo:nil];
        
    }];
}

#pragma mark - Security: Input data validation

// Doesnt matter what is the cause of the 'NO return', it always gonna blank the text field and wait for a valid information.
- (BOOL)validateGoalName:(NSString *)newGoalName{
    
    NSRange match = [newGoalName rangeOfString:@"["];
    NSRange match2 = [newGoalName rangeOfString:@"("];
    
    if(match.location == NSNotFound && match2.location == NSNotFound){
        
        return YES;
    } else{
        
        return NO;
    }
}

#pragma mark - Notification Messages

- (void)notificationsToTheUser:(NSString *)newNotification{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:newNotification preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
    
}


@end
