//
//  CLRMMenuColorViewController.m
//  Classroom
//
//  Created by Julio Rodríguez on 07/07/14.
//
//

#import "CLRMMenuColorViewController.h"
#import "NKOColorPickerView.h"

@implementation CLRMMenuColorViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set the title of the Navigation Bar
    [[self navigationItem] setTitle:@"Menu Color"];
    
    // Set the navigation bar not translucent
    // so the view isn't covered
    self.navigationController.navigationBar.translucent = NO;
    
    // Create a label
    UILabel *menuColorPickerLabel = [[UILabel alloc]
                                     initWithFrame:CGRectMake(20, 20, 150, 28)];
    
    [menuColorPickerLabel setText:@"Menu Color Picker"];
    
    [self.view addSubview:menuColorPickerLabel];
    
    
    //============================================================================================================
    
    // ColorPickerDidChangeColor block declaration
    // Called each time the cross hair moves when selecting a color
    NKOColorPickerDidChangeColorBlock colorDidChangeBlock = ^(UIColor *color) {
        
        // The code handling a color change in the picker view.
        
        // Create an NSData with the current color
        NSData *colorData = [NSKeyedArchiver archivedDataWithRootObject:color];
        
        // Save it in the UserDefaults system
        [[NSUserDefaults standardUserDefaults] setObject:colorData forKey:@"Menu Bar Color"];
        
    };
    
    // Get the data of the color saved in the UserDefaults system
    NSData *menuBarData = [[NSUserDefaults standardUserDefaults] objectForKey:@"Menu Bar Color"];
    
    // Create a color with that data
    UIColor *menuBarColor = [NSKeyedUnarchiver unarchiveObjectWithData:menuBarData];
    
    // Create the NKOColorPickerView, and make it appear on screen
    NKOColorPickerView *colorPickerView = [[NKOColorPickerView alloc] initWithFrame:CGRectMake(0, 50, 320, 340)
                                                                              color:menuBarColor
                                                             andDidChangeColorBlock:colorDidChangeBlock];
    //Add color picker to the view
    [self.view addSubview:colorPickerView];
    
    //============================================================================================================
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


- (id)init
{
    self = [super init];
    
    if (self) {
        
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
    
    return self;
}

@end
