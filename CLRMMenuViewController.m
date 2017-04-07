//
//  CLRMMenuViewController.m
//  Classroom
//
//  Created by Julio Rodríguez on 01/06/14.
//
//

#import "CLRMMenuViewController.h"

#import "CLRMHomeworkViewController.h"
#import "CLRMRemindersViewController.h"
#import "CLRMBrowserViewController.h"

#import "CLRMInfoViewController.h"

@implementation CLRMMenuViewController

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    // If the user taps on the first section
    if ([indexPath section] == 0) {
        
        // If the user taps the first row (Homework)
        if ([indexPath row] == 0) {
            
            // Make the Homework view controller appear on screen
            CLRMHomeworkViewController *homeworkViewController = [[CLRMHomeworkViewController alloc] init];
            
            UINavigationController *homeworkNavigationController = [[UINavigationController alloc]
                                                                    initWithRootViewController:homeworkViewController];
            [[homeworkNavigationController navigationBar]
             setBarTintColor:[UIColor colorWithRed:1.0 green:0.5 blue:0.0 alpha:1.0]]; // Orange
            
            [homeworkNavigationController setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
            
            [self presentViewController:homeworkNavigationController animated:YES completion:nil];
        }
        
        // If the user taps on the second row (Reminders)
        if ([indexPath row] == 1) {
            
            // Make the Reminders view controller appear on screen
            CLRMRemindersViewController *remindersViewController = [[CLRMRemindersViewController alloc] init];
            
            UINavigationController *remindersNavigationController = [[UINavigationController alloc] initWithRootViewController:remindersViewController];
            
            [[remindersNavigationController navigationBar] setBarTintColor:[UIColor colorWithRed:0.5 green:1.0 blue:0.3 alpha:1.0]]; // Green
            
            [remindersNavigationController setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
            
            [self presentViewController:remindersNavigationController animated:YES completion:nil];
        }
        
        // If the user taps on the fourth row (Browser)
        if ([indexPath row] == 2) {
            
            // Create a Browser view controller variable that is nil and static
            static CLRMBrowserViewController *browserViewController;
            
            // If this is the first time the user taps the row
            if (!browserViewController) {
                
                // Create a new Browser view controller
                browserViewController = [[CLRMBrowserViewController alloc] init];
                
                // Modify its appearance and transition
                UINavigationController *browserNavigationController = [[UINavigationController alloc] initWithRootViewController:browserViewController];
                [[browserNavigationController navigationBar] setBarTintColor:[UIColor colorWithRed:0.0 green:0.7 blue:1.0 alpha:1.0]]; // Blue
                [browserNavigationController setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
                
                // Present it
                [self presentViewController:browserNavigationController animated:YES completion:nil];
                
            } else {
                
                // If is not the first time the uset taps the row...
                
                // Only make the Browser appear (don't create a new instance)
                UINavigationController *browserNavigationController = [[UINavigationController alloc] initWithRootViewController:browserViewController];
                
                [[browserNavigationController navigationBar] setBarTintColor:[UIColor colorWithRed:0.0 green:0.7 blue:1.0 alpha:1.0]]; // Blue
                
                [browserNavigationController setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
                
                [self presentViewController:browserNavigationController animated:YES completion:nil];
            }
            
            
        }
        
        // If the user taps on the fifth row (Settings)
        if ([indexPath row] == 3) {
            
            UIStoryboard *infoStoryboard = [UIStoryboard storyboardWithName:@"CLRMSettingsViewController" bundle:nil];
            
            UIViewController *infoInitialViewController = [infoStoryboard instantiateInitialViewController];
            
            UINavigationController *infoNavigationController = [[UINavigationController alloc] initWithRootViewController:infoInitialViewController];
            
            [[infoNavigationController navigationBar] setBarTintColor:[UIColor colorWithRed:0.75 green:0.75 blue:0.75 alpha:1.0]];
            
            infoNavigationController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
            
            [self presentViewController:infoNavigationController animated:YES completion:nil];
        }
    }
    
    // If the user taps on the second section
    if ([indexPath section] == 1) {
        
        // If the user taps on the first row (Info)
        if ([indexPath row] == 0) {
            
            UIStoryboard *infoStoryboard = [UIStoryboard storyboardWithName:@"CLRMInfoViewController" bundle:nil];
            
            UIViewController *infoInitialViewController = [infoStoryboard instantiateInitialViewController];
            
            UINavigationController *infoNavigationController = [[UINavigationController alloc] initWithRootViewController:infoInitialViewController];
            
            infoNavigationController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
            
            [self presentViewController:infoNavigationController animated:YES completion:nil];
        }
        
        
        // If the user taps on the second row (Rate This App)
        if ([indexPath row] == 1) {
            
            // Classroom URL to the App Store
            NSURL *classroomURL = [NSURL URLWithString:@"https://itunes.apple.com/us/app/classroom-students-helper/id896974863?l=es&mt=8"];
            
            // Open the App Store
            [[UIApplication sharedApplication] openURL:classroomURL];
        }
        
        
        // If the user taps on the third row (Like on Facebook)
        if ([indexPath row] == 2) {
            
            // Determine with a BOOL, if the user has the Facebook App installed
            BOOL facebookAppInstalled = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"fb://"]];
            
            // If the user has the app...
            if (facebookAppInstalled == YES) {
                
                // Open Classroom page with the app
                NSURL *facebookPageURL = [NSURL URLWithString:@"fb://page?id=652374564855426"];
                [[UIApplication sharedApplication] openURL:facebookPageURL];
                
            } else {
                
                // If the user doesn't has the app...
                
                // Open Classroom page with safari
                NSURL *facebookPageURL = [NSURL URLWithString:@"https://www.facebook.com/pages/Classroom/652374564855426"];
                [[UIApplication sharedApplication] openURL:facebookPageURL];
            }
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[self navigationItem] setTitle:@"Menu"];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Get the NSData saved in the UserDefaults system
    NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"Menu Bar Color"];
    
    // If the data doesn't exist
    if (!colorData) {
        
        // Set the Menu Bar Color and the background to blue
        UIColor *customBlueColor = [UIColor colorWithRed:0.0 green:0.5 blue:1.0 alpha:1.0];
        
        self.navigationController.navigationBar.barTintColor = customBlueColor;
        self.tableView.backgroundColor = customBlueColor;
        
        // Save the data
        NSData *colorData = [NSKeyedArchiver archivedDataWithRootObject:customBlueColor];
        
        [[NSUserDefaults standardUserDefaults] setObject:colorData forKey:@"Menu Bar Color"];
        
        return;
    }
    
    // Make a color with the saved data
    UIColor *color = [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
    
    // Set the color of the Menu Bar and the background view
    self.navigationController.navigationBar.barTintColor = color;
    self.tableView.backgroundColor = color;
}

@end
