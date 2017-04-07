//
//  CLRMWebPageDetailViewController.m
//  Classroom
//
//  Created by Julio Rodríguez on 27/02/14.
//
//

#import "CLRMWebPageDetailViewController.h"
#import "CLRMWebPageStore.h"
#import "CLRMWebPage.h"

@interface CLRMWebPageDetailViewController ()

@end

@implementation CLRMWebPageDetailViewController

#pragma mark - @synthesize declarations

@synthesize webPageTextField = _webPageTextField;
@synthesize urlTextField = _urlTextField;

@synthesize correspondingWebPage = _correspondingWebPage;



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set the translucency to NO, so the WebPageDetail XIB
    // isn't covered by the Navigation Bar
    self.navigationController.navigationBar.translucent = NO;
    
    // Set the _webPageTextField and _urlTextField to display a default keyboard
    _webPageTextField.keyboardType = UIKeyboardTypeDefault;
    _urlTextField.keyboardType = UIKeyboardTypeDefault;
    
    [_webPageTextField becomeFirstResponder];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[self view] endEditing:YES];
    
    // Set the UI elements to match the corresponding CLRMWebPage instance
    [_webPageTextField setText:[_correspondingWebPage webPageName]];
    [_urlTextField setText:[_correspondingWebPage webPageURL]];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // Save changes made in the Web Page Detail view to corresponding web page
    [_correspondingWebPage setWebPageName:[_webPageTextField text]];
    [_correspondingWebPage setWebPageURL:[_urlTextField text]];
}


#pragma mark - IBActions

- (void)save:(id)sender
{
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}


- (void)cancel:(id)sender
{
    // If the user cancelled, remove the CLRMWebPage instance from the store
    [[CLRMWebPageStore sharedStore] removeWebPage:_correspondingWebPage];
    
    // Dismiss the view controller
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - initializers

- (id)initForNewWebPage:(BOOL)isNew
{
    self = [super initWithNibName:@"CLRMWebPageDetailViewController" bundle:nil];
    
    if (self) {
        
        if (isNew) {
            
            // Set the title of the New Web Page window
            [[self navigationItem] setTitle:@"New Web Page"];
            
            // Create a "Done" button and set it as the right bar button item of the navigation bar
            UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                                                                      target:self
                                                                                      action:@selector(save:)];
            [[self navigationItem] setRightBarButtonItem:doneItem];
            
            // Create a "Cancel" button and set it as the left bar button item of the navigation bar
            UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                        target:self
                                                                                        action:@selector(cancel:)];
            [[self navigationItem] setLeftBarButtonItem:cancelItem];
            
            // Set the color of the navigation bar
            [[[self navigationController] navigationBar] setBarTintColor:[UIColor colorWithRed:0.0 green:0.7 blue:1.0 alpha:1.0]];
            
        } else {
            
            // If the Web Page instance is not new, set the navigation bar title "Detail"
            UINavigationItem *navigationItem = [self navigationItem];
            [navigationItem setTitle:@"Detail"];
            
            // Set the color of the navigation bar
            [[[self navigationController] navigationBar] setBarTintColor:[UIColor colorWithRed:0.0 green:0.7 blue:1.0 alpha:1.0]];

        }
    }
    
    return self;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    @throw [NSException exceptionWithName:@"Wrong Initializer"
                                   reason:@"Use initForNewWebPage:"
                                 userInfo:nil];
    
    return self;
}


#pragma mark - UITextFieldDelegate methods and keyboard hide methods

// This method dismisses the keyboard if "Return" is tapped on the keyboard
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"text");
    [textField resignFirstResponder];
    return YES;
}



@end
