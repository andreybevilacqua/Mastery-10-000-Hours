//
//  CreateGoalViewController.h
//  Mastery 10,000 Hours
//
//  Created by Andrey Bevilacqua on 6/25/16.
//  Copyright © 2016 Andrey Bevilacqua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoalsDB.h"

@interface CreateGoalViewController : UIViewController{
    
    GoalsDB *goalsDB;
}

@property (strong, nonatomic) IBOutlet UITextField *textFieldGoalName;

- (IBAction)buttonSaveGoal:(id)sender;

- (IBAction)buttonCancelGoal:(id)sender;

- (BOOL)validateGoalName:(NSString *)newGoalName;

- (void)notificationsToTheUser:(NSString *)newNotification;

@end
