//
//  CLRMSettingsViewController.m
//  Classroom
//
//  Created by Julio Rodríguez on 08/06/14.
//
//

#import "CLRMSettingsViewController.h"

#import "CLRMMenuColorViewController.h"

@implementation CLRMSettingsViewController

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    // If the user taps on the first section
    if ([indexPath section] == 0) {
        
        // If the user taps the first row
        if ([indexPath row] == 0) {
            
            // Make the Menu Color view controller appear
            CLRMMenuColorViewController *menuColorViewController = [[CLRMMenuColorViewController alloc] init];
            
            UINavigationController *colorPickerNavigationController = [[UINavigationController alloc] initWithRootViewController:menuColorViewController];
            
            
            
            [[colorPickerNavigationController navigationBar] setBarTintColor:[UIColor colorWithRed:0.75
                                                                                            green:0.75
                                                                                             blue:0.75
                                                                                            alpha:1.0]];
            
            [self presentViewController:colorPickerNavigationController animated:YES completion:nil];
        }
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [[self navigationItem] setTitle:@"Settings"];
    
    // Make an image with Menu_Icon
    UIImage *menuIcon = [UIImage imageNamed:@"Menu_Icon"];
    
    // Create the bar button item that will send showMenu:
    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc]
                                   initWithImage:menuIcon
                                   style:UIBarButtonItemStylePlain
                                   target:self
                                   action:@selector(showMenu:)];
    
    // Set menuButton as the left item in the navigationItem
    [[self navigationItem] setLeftBarButtonItem:menuButton];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}


- (IBAction)showMenu:(id)sender
{
    // Dismiss the view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
