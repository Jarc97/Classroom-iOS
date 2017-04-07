//
//  CLRMInfoViewController.m
//  Classroom
//
//  Created by Julio Rodríguez on 07/06/14.
//
//

#import "CLRMInfoViewController.h"

@implementation CLRMInfoViewController

@synthesize userGuideButton = _userGuideButton;
@synthesize newsAndUpdatesButton = _newsAndUpdatesButton;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set the title of the Navigation Bar
    [[self navigationItem] setTitle:@"Info"];
    
    // Set the navigation bar not translucent
    // so the view isn't covered
    self.navigationController.navigationBar.translucent = NO;
    
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
    
    // Make the User Guide button appear as a round button
    _userGuideButton.layer.cornerRadius = 5;
    _userGuideButton.layer.borderWidth = 1;
    _userGuideButton.layer.borderColor = _userGuideButton.tintColor.CGColor;
    
    // Make the Change Log button appear as a round button
    _newsAndUpdatesButton.layer.cornerRadius = 5;
    _newsAndUpdatesButton.layer.borderWidth = 1;
    _newsAndUpdatesButton.layer.borderColor = _newsAndUpdatesButton.tintColor.CGColor;
}


- (IBAction)showMenu:(id)sender
{
    // Dismiss the view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)showUserGuide:(id)sender
{
    UIStoryboard *infoStoryboard = [UIStoryboard storyboardWithName:@"CLRMUserGuideViewController" bundle:nil];
    
    UIViewController *infoInitialViewController = [infoStoryboard instantiateInitialViewController];
    
    UINavigationController *infoNavigationController = [[UINavigationController alloc] initWithRootViewController:infoInitialViewController];
    
    // Present the view controller so it takes all the screen
    infoNavigationController.modalPresentationStyle = UIModalPresentationFullScreen;
    
    [self presentViewController:infoNavigationController animated:YES completion:nil];
}


- (void)showNewsAndUpdates:(id)sender
{
    UIStoryboard *infoStoryboard = [UIStoryboard storyboardWithName:@"CLRMNewsAndUpdatesViewController" bundle:nil];
    
    UIViewController *infoInitialViewController = [infoStoryboard instantiateInitialViewController];
    
    UINavigationController *infoNavigationController = [[UINavigationController alloc] initWithRootViewController:infoInitialViewController];
    
    // Present the view controller so it takes all the screen
    infoNavigationController.modalPresentationStyle = UIModalPresentationFullScreen;
    
    [self presentViewController:infoNavigationController animated:YES completion:nil];
}








@end
