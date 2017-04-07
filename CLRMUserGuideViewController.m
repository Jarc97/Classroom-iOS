//
//  CLRMUserGuideViewController.m
//  Classroom
//
//  Created by Julio Rodríguez on 09/06/14.
//
//

#import "CLRMUserGuideViewController.h"

@implementation CLRMUserGuideViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[self navigationItem] setTitle:@"User's Guide"];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                target:self
                                                                                action:@selector(done:)];
    [[self navigationItem] setRightBarButtonItem:doneButton];
}


- (IBAction)done:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
