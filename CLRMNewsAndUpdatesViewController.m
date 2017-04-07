//
//  CLRMNewsAndUpdatesViewController.m
//  Classroom
//
//  Created by Julio Rodríguez on 21/07/14.
//
//

#import "CLRMNewsAndUpdatesViewController.h"

@implementation CLRMNewsAndUpdatesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Change the title of the navigation bar
    [[self navigationItem] setTitle:@"News and Updates"];
    
    // Create a bar button and set it as the right button
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                target:self
                                                                                action:@selector(done:)];
    [[self navigationItem] setRightBarButtonItem:doneButton];
}


- (IBAction)done:(id)sender
{
    // When Done is pressed, dismiss the view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
