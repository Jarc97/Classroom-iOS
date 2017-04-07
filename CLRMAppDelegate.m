//
//  CLRMAppDelegate.m
//  Classroom
//
//  Created by Julio Rodríguez on 03/02/14.
//
//

#import "CLRMAppDelegate.h"

#import "CLRMHomeworkViewController.h"
#import "CLRMHomeworkStore.h"

#import "CLRMRemindersViewController.h"
#import "CLRMReminderStore.h"

#import "CLRMWebPageStore.h"

#import "CLRMMenuViewController.h"

@implementation CLRMAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    // Load the Menu view controller
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"CLRMMenuViewController" bundle:[NSBundle mainBundle]];
    UIViewController *menuViewController =[storyboard instantiateInitialViewController];
    
    // Put a Navigation Bar on every view controller that needs it
    UINavigationController *menuNavigationController = [[UINavigationController alloc]
                                                            initWithRootViewController:menuViewController];
    // Set the root view controller
    [[self window] setRootViewController:menuNavigationController];
    
    // Set the icon badge to zero
    application.applicationIconBadgeNumber = 0;
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}


// Called when a Local Notification comes in and the user is using the app
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    // Check Classroom state
    UIApplicationState appState = [application applicationState];
    
    // If the state is active...
    if (appState == UIApplicationStateActive) {
        
        // Show the user the alert
        UIAlertView *alertWhenActive = [[UIAlertView alloc] initWithTitle:@"Notification"
                                                        message:notification.alertBody
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alertWhenActive show];
        
        // And set the icon badge to zero
        application.applicationIconBadgeNumber = 0;
        
        return;
    }
    
    
    // Check if the type of notification is Homework
    if ([notification.userInfo  isEqual: @{@"Type" : @"Homework"}]) {
        
        // Create an enumerator
        NSEnumerator *homeworkEnumerator = [[[CLRMHomeworkStore sharedStore] allCreatedHomework] objectEnumerator];
        
        // Create a Homework instance
        CLRMHomework *homework;
        
        // Loop with the enumerator to get a specific Homework
        while (homework = [homeworkEnumerator nextObject]) {
            
            /* code to act on each element as it is returned */
            
            // If the Homework title text is equal to the notification alertBody text...
            if ([homework.homeworkTitle isEqualToString:notification.alertBody]) {
                
                // Get the ivars of the specific Homework
                NSString *homeworkTitle = [homework homeworkTitle];
                NSString *homeworkCourse = [homework homeworkCourse];
                NSString *homeworkTeacher = [homework homeworkTeacher];
                NSString *homeworkNotes = [homework homeworkNotes];
                
                // Make the text to display
                NSString *displayBody =
                [[NSString alloc] initWithFormat:@"\n%@\n%@\n%@\n\n%@", homeworkTitle, homeworkCourse, homeworkTeacher, homeworkNotes];
                
                // Display to the user the notification
                UIAlertView *alertWhenNotActive = [[UIAlertView alloc] initWithTitle:@"Notification Display"
                                                                             message:displayBody
                                                                            delegate:nil
                                                                   cancelButtonTitle:@"OK"
                                                                   otherButtonTitles:nil];
                [alertWhenNotActive show];
            }
        }
    }
    
    
    // Check if the type of notification is Reminder
    if ([notification.userInfo  isEqual: @{@"Type" : @"Reminder"}]) {
        
        // Create an enumerator
        NSEnumerator *reminderEnumerator = [[[CLRMReminderStore sharedStore] allCreatedReminders] objectEnumerator];
        
        // Create a Reminder instance
        CLRMReminder *reminder;
        
        // Loop with the enumerator to get a specific Reminder
        while (reminder = [reminderEnumerator nextObject]) {
            
            /* code to act on each element as it is returned */
            
            // If the Reminder title text is equal to the notification alertBody text...
            if ([reminder.reminderTitle isEqualToString:notification.alertBody]) {
                
                // Get the ivars of the specific Reminder
                NSString *reminderTitle = [reminder reminderTitle];
                NSString *reminderNotes = [reminder reminderNotes];
                
                // Make the text to display
                NSString *displayBody =
                [[NSString alloc] initWithFormat:@"\n%@\n%@", reminderTitle, reminderNotes];
                
                // Display to the user the notification
                UIAlertView *alertWhenNotActive = [[UIAlertView alloc] initWithTitle:@"Notification Display"
                                                                             message:displayBody
                                                                            delegate:nil
                                                                   cancelButtonTitle:@"OK"
                                                                   otherButtonTitles:nil];
                [alertWhenNotActive show];
            }
        }
    }
    
    // Set icon badge number to zero
    application.applicationIconBadgeNumber = 0;
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    // Save all changes made in the Homework list
    BOOL successSavingHomework = [[CLRMHomeworkStore sharedStore] saveChanges];
    
    if (successSavingHomework) {
        NSLog(@"Saved all the Homework");
    } else {
        NSLog(@"Could not save any of the Homework");
    }
    
    
    // Save all changes made in the Reminders List
    BOOL successSavingReminders = [[CLRMReminderStore sharedStore] saveChanges];
    
    if (successSavingReminders) {
        NSLog(@"Saved all the Reminders");
    } else {
        NSLog(@"Could not save any of the Reminders");
    }
    
    
    // Save all the changes made in the Web Page list
    BOOL successSavingWebPages = [[CLRMWebPageStore sharedStore] saveChanges];
    
    if (successSavingWebPages) {
        NSLog(@"Saved all the Web Pages");
    } else {
        NSLog(@"Could not save any of the Web Pages");
    }
}


- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    // Maybe refresh all the table views when iCloud feature is enabled.
    
    // Remove the app badge every time the app becomes active
    application.applicationIconBadgeNumber = 0;
}


- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    // Set the Browser current web page to google
    // so that when the user enters the app after terminating it, google will open
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *googleURL = @"http://www.google.com";
    [userDefaults setObject:googleURL forKey:@"Browser Current Web Page"];
}

@end
